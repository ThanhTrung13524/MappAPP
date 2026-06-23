// lib/data/repositories/tourism_repository.dart

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/tourism_dao.dart';
import '../../core/database/daos/administrative_unit_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../api/overpass_api_client.dart';
import '../api/wikipedia_service.dart';
import '../geojson/vietnam_geo_validator.dart';

final tourismRepositoryProvider = Provider<TourismRepository>((ref) {
  return TourismRepository(
    tourismDao: ref.watch(tourismDaoProvider),
    unitDao: ref.watch(administrativeUnitDaoProvider),
    overpassClient: ref.watch(overpassApiClientProvider),
    wikipediaService: ref.watch(wikipediaServiceProvider),
  );
});

class TourismRepository {
  final TourismDao _tourismDao;
  final AdministrativeUnitDao _unitDao;
  final OverpassApiClient _overpassClient;
  final WikipediaService _wikipediaService;

  // FIX: Use initializing formals instead of manual field assignment
  TourismRepository({
    required this._tourismDao,
    required this._unitDao,
    required this._overpassClient,
    required this._wikipediaService,
  });

  // ─── Seed ──────────────────────────────────────────────────

  Stream<double> seedTourismData({
    CancelToken? cancelToken,
    int cols = 4,
    int rows = 4,
    required VietnamGeoValidator validator,
    void Function(String event, Map<String, Object?> data)? telemetry,
  }) async* {
    yield 0.0;
    try {
      final prefs = await SharedPreferences.getInstance();
      final alreadySeeded = prefs.getBool('seeded_tourism_v4') ?? false;
      if (alreadySeeded) return;

      telemetry?.call('seed_started', {'cols': cols, 'rows': rows});

      // Prepare provinces for nearest lookup
      final provinces = await _unitDao.getAllProvinces();

      // Grid bounds (Vietnam conservative bbox)
      const lonMin = 102.14, latMin = 8.18, lonMax = 109.46, latMax = 23.39;
      final lonStep = (lonMax - lonMin) / cols;
      final latStep = (latMax - latMin) / rows;

      final totalCells = cols * rows;
      var completedCells = 0;
      var acceptedCount = 0;
      var acceptedProvinceFallbackCount = 0;
      var rejectedBBoxCount = 0;
      var rejectedBoundaryCount = 0;
      var rejectedNoProvinceCount = 0;
      final seen = <int>{};
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          if (cancelToken?.isCancelled == true) {
            telemetry?.call('seed_cancelled', {'r': r, 'c': c});
            return;
          }

          final cellLonMin = lonMin + c * lonStep;
          final cellLonMax = lonMin + (c + 1) * lonStep;
          final cellLatMin = latMin + r * latStep;
          final cellLatMax = latMin + (r + 1) * latStep;

          List<OverpassPlace> cellPlaces = [];
          try {
            cellPlaces = await _overpassClient.fetchByBbox(
              lonMin: cellLonMin,
              latMin: cellLatMin,
              lonMax: cellLonMax,
              latMax: cellLatMax,
              cancelToken: cancelToken,
              cacheTtl: const Duration(days: 7),
            );
            telemetry?.call('cell_fetched', {
              'r': r,
              'c': c,
              'count': cellPlaces.length,
            });
          } catch (e) {
            telemetry?.call('cell_error', {
              'r': r,
              'c': c,
              'error': e.toString(),
            });
            debugPrint('TourismRepository: cell fetch error ($c,$r): $e');
          }

          final toPersist = <TourismPlace>[];
          for (final p in cellPlaces) {
            if (seen.contains(p.id)) continue;
            seen.add(p.id);

            final provinceMa = _findNearestProvince(p.lat, p.lon, provinces);
            if (!validator.isInsideVietnamBBox(p.lat, p.lon)) {
              rejectedBBoxCount++;
              telemetry?.call('poi_rejected_bbox', {'osmId': p.id});
              continue;
            }

            final isInsideBoundary = validator.isInsideVietnamBoundary(
              p.lat,
              p.lon,
            );
            final hasProvinceFallback = provinceMa != null &&
                validator.isInsideVietnamBBox(p.lat, p.lon);
            if (!isInsideBoundary && !hasProvinceFallback) {
              rejectedBoundaryCount++;
              telemetry?.call('poi_rejected_boundary', {'osmId': p.id});
              continue;
            }
            if (!isInsideBoundary && hasProvinceFallback) {
              acceptedProvinceFallbackCount++;
            }

            if (provinceMa == null) {
              rejectedNoProvinceCount++;
              telemetry?.call('poi_without_nearest_province', {'osmId': p.id});
            }

            final tags = p.tags;
            final category = _resolveCategoryString(tags);
            // Skip beach and nature landmarks
            if (category == 'beach' ||
                category == 'nationalPark' ||
                category == 'national_park' ||
                category == 'nature' ||
                category == 'natural_park' ||
                category == 'nature_reserve') {
              continue;
            }

            toPersist.add(
              TourismPlace(
                osmId: p.id,
                name: p.name.isNotEmpty ? p.name : '',
                nameEn: tags['name:en'],
                nameZh: tags['name:zh'],
                category: category,
                lat: p.lat,
                lon: p.lon,
                description: tags['description'] ?? tags['description:en'],
                wikiSummary: null,
                thumbnailUrl: null,
                website: tags['website'] ?? tags['contact:website'],
                openingHours: tags['opening_hours'],
                phone: tags['phone'] ?? tags['contact:phone'],
                wikidata: tags['wikidata'],
                wikipedia: tags['wikipedia'],
                provinceMa: provinceMa,
                wikiLastFetched: null,
              ),
            );
            acceptedCount++;
          }

          if (toPersist.isNotEmpty) {
            try {
              await _tourismDao.upsertPlaces(toPersist);
              telemetry?.call('persist_chunk', {'count': toPersist.length});
            } catch (e) {
              telemetry?.call('persist_error', {'error': e.toString()});
              debugPrint('TourismRepository: persist error: $e');
            }
          }

          completedCells++;
          yield completedCells / totalCells;

          // Avoid burst requests
          await Future.delayed(const Duration(milliseconds: 600));
        }
      }

      await SharedPreferences.getInstance().then(
        (p) async => p.setBool('seeded_tourism_v4', true),
      );
      telemetry?.call('seed_completed', {
        'items': seen.length,
        'accepted': acceptedCount,
        'accepted_province_fallback': acceptedProvinceFallbackCount,
        'rejected_bbox': rejectedBBoxCount,
        'rejected_boundary': rejectedBoundaryCount,
        'without_nearest_province': rejectedNoProvinceCount,
      });
      debugPrint(
        'TourismRepository: seeded accepted=$acceptedCount, seen=${seen.length}, '
        'acceptedProvinceFallback=$acceptedProvinceFallbackCount, '
        'rejectedBBox=$rejectedBBoxCount, '
        'rejectedBoundary=$rejectedBoundaryCount, '
        'withoutNearestProvince=$rejectedNoProvinceCount',
      );
    } catch (e) {
      telemetry?.call('seed_failed', {'error': e.toString()});
      debugPrint('TourismRepository: seed error: $e');
      yield 1.0;
    }
  }

  // ─── Lazy Wiki Fetch ────────────────────────────────────────

  Future<TourismPlace> ensureWikiSummary(TourismPlace place) async {
    if (place.wikiSummary != null && place.wikiSummary!.isNotEmpty) {
      return place;
    }
    return await _fetchAndCacheWiki(place) ?? place;
  }

  Future<TourismPlace?> _fetchAndCacheWiki(TourismPlace place) async {
    final searchTerm =
        place.wikidata ??
        place.wikipedia?.replaceFirst('en:', '') ??
        place.nameEn ??
        place.name;

    final summary = await _wikipediaService.getSummary(searchTerm);
    if (summary == null) return null;

    await _tourismDao.updateWikiSummary(
      osmId: place.osmId,
      summary: summary.extract,
      thumbnailUrl: summary.thumbnailUrl,
    );

    // FIX: dùng copyWith với named params trực tiếp
    // TourismPlace (Drift DataClass) dùng copyWith(field: value) — không dùng Value()
    return place.copyWith(
      wikiSummary: Value(summary.extract),
      thumbnailUrl: Value(summary.thumbnailUrl),
    );
  }

  // ─── Queries ────────────────────────────────────────────────

  Future<List<TourismPlace>> getAll() => _tourismDao.getAll();
  Future<List<TourismPlace>> getByProvince(String ma) =>
      _tourismDao.getByProvince(ma);
  Future<List<TourismPlace>> getWorldHeritage() =>
      _tourismDao.getWorldHeritage();
  Future<List<TourismPlace>> search(String q) => _tourismDao.search(q);
  Future<int> count() => _tourismDao.count();

  Future<int> deleteInvalidPlaces() => _tourismDao.deleteInvalidPlaces();

  Future<int> cleanupInvalidVietnamPois(VietnamGeoValidator validator) async {
    final bboxDeleted = await _tourismDao.deleteOutsideVietnamBBox(
      latMin: vietnamMinLat,
      latMax: vietnamMaxLat,
      lonMin: vietnamMinLng,
      lonMax: vietnamMaxLng,
    );

    final remaining = await _tourismDao.getAll();
    final invalidIds = <int>[];
    var validBoundaryCount = 0;

    if (!validator.hasBoundaryData) {
      debugPrint(
        'TourismRepository: boundary unavailable; cleanup limited to bbox only',
      );
      return bboxDeleted;
    }

    for (final place in remaining) {
      if (!validator.isValidVietnamPoi(lat: place.lat, lng: place.lon)) {
        invalidIds.add(place.osmId);
      } else {
        validBoundaryCount++;
      }
    }

    if (validBoundaryCount == 0 && remaining.isNotEmpty) {
      debugPrint(
        'TourismRepository: boundary validator matched 0/${remaining.length} POIs; '
        'skipping polygon cleanup to avoid wiping landmarks.',
      );
      return bboxDeleted;
    }

    if (invalidIds.isNotEmpty) {
      await _tourismDao.deletePlaces(invalidIds);
    }

    final deleted = bboxDeleted + invalidIds.length;
    debugPrint(
      'TourismRepository: cleanup removed $deleted invalid POIs '
      '(bbox=$bboxDeleted, boundary=${invalidIds.length})',
    );
    return deleted;
  }

  Future<List<TourismPlace>> getInBounds({
    required double minLat,
    required double maxLat,
    required double minLon,
    required double maxLon,
  }) => _tourismDao.getInBounds(
    minLat: minLat,
    maxLat: maxLat,
    minLon: minLon,
    maxLon: maxLon,
  );

  // ─── Helper ─────────────────────────────────────────────────

  String? _findNearestProvince(
    double lat,
    double lon,
    List<AdministrativeUnit> provinces,
  ) {
    if (provinces.isEmpty) return null;
    AdministrativeUnit? nearest;
    double minDist = double.infinity;
    for (final p in provinces) {
      if (p.centroidLat == null || p.centroidLon == null) continue;
      final d = _dist(lat, lon, p.centroidLat!, p.centroidLon!);
      if (d < minDist) {
        minDist = d;
        nearest = p;
      }
    }
    return minDist < 1.0 ? nearest?.ma : null;
  }

  double _dist(double lat1, double lon1, double lat2, double lon2) =>
      sqrt(pow(lat1 - lat2, 2) + pow(lon1 - lon2, 2));

  // Resolve a simple category string from OSM tags. Conservative mapping —
  // used for simple filtering and feature pages.
  String _resolveCategoryString(Map<String, String?> tags) {
    final tourism = tags['tourism'];
    final historic = tags['historic'];
    final amenity = tags['amenity'];
    final heritage = tags['heritage'];

    if (heritage == 'world_heritage') return 'worldHeritage';
    if (tourism != null && tourism.isNotEmpty) return tourism;
    if (historic != null && historic.isNotEmpty) return historic;
    if (amenity != null && amenity.isNotEmpty) return amenity;

    // Fallback categories
    if (tags['natural'] != null) return tags['natural']!;
    if (tags['leisure'] != null) return tags['leisure']!;
    return 'other';
  }
}
