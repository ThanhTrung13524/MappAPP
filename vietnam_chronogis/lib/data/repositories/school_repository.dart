import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/school_dao.dart';
import '../../core/database/daos/administrative_unit_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../api/overpass_api_client.dart';
import '../api/nemotron_api_client.dart';
import '../geojson/vietnam_geo_validator.dart';

final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  return SchoolRepository(
    schoolDao: ref.watch(schoolDaoProvider),
    unitDao: ref.watch(administrativeUnitDaoProvider),
    overpassClient: ref.watch(overpassApiClientProvider),
  );
});

class SchoolRepository {
  final SchoolDao _schoolDao;
  final AdministrativeUnitDao _unitDao;
  final OverpassApiClient _overpassClient;

  SchoolRepository({
    required SchoolDao schoolDao,
    required AdministrativeUnitDao unitDao,
    required OverpassApiClient overpassClient,
  })  : _schoolDao = schoolDao,
        _unitDao = unitDao,
        _overpassClient = overpassClient;

  Stream<double> seedSchools({
    CancelToken? cancelToken,
    int cols = 3,
    int rows = 3,
    required VietnamGeoValidator validator,
  }) async* {
    yield 0.0;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('seeded_schools_v1') ?? false) {
        yield 1.0;
        return;
      }

      const lonMin = 102.14, latMin = 8.18, lonMax = 109.46, latMax = 23.39;
      final lonStep = (lonMax - lonMin) / cols;
      final latStep = (latMax - latMin) / rows;
      final provinces = await _unitDao.getAllProvinces();
      final totalCells = cols * rows;
      var completedCells = 0;
      final seen = <int>{};

      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
          if (cancelToken?.isCancelled == true) return;

          final cellLonMin = lonMin + c * lonStep;
          final cellLonMax = lonMin + (c + 1) * lonStep;
          final cellLatMin = latMin + r * latStep;
          final cellLatMax = latMin + (r + 1) * latStep;

          List<OverpassPlace> cellPlaces = [];
          try {
            cellPlaces = await _overpassClient.fetchSchoolsByBbox(
              lonMin: cellLonMin,
              latMin: cellLatMin,
              lonMax: cellLonMax,
              latMax: cellLatMax,
              cancelToken: cancelToken,
              cacheTtl: const Duration(days: 7),
            );
          } catch (e) {
            debugPrint('SchoolRepository: cell fetch error ($c,$r): $e');
          }

          final toPersist = <School>[];
          for (final p in cellPlaces) {
            if (seen.contains(p.id)) continue;
            seen.add(p.id);
            if (!validator.isInsideVietnamBBox(p.lat, p.lon)) continue;
            if (p.name.trim().isEmpty) continue;

            final nearest = _findNearestProvince(p.lat, p.lon, provinces);
            final schoolType = _detectSchoolType(p);
            toPersist.add(
              School(
                osmId: p.id,
                name: p.name,
                schoolType: schoolType,
                lat: p.lat,
                lon: p.lon,
                address: p.tags['addr:full'] ?? p.tags['address'],
                phone: p.tags['phone'] ?? p.tags['contact:phone'],
                website: p.tags['website'] ?? p.tags['contact:website'],
                provinceMa: nearest?.ma,
                provinceName: nearest?.ten,
                operator: p.tags['operator'],
                nemotronRegion: nemotronRegionForProvince(
                  nearest?.ten,
                  nearest?.ma,
                ),
              ),
            );
          }

          if (toPersist.isNotEmpty) {
            await _schoolDao.upsertSchools(toPersist);
          }

          completedCells++;
          yield completedCells / totalCells;
        }
      }

      await prefs.setBool('seeded_schools_v1', true);
      debugPrint('SchoolRepository: seeded ${seen.length} THPT schools');
      yield 1.0;
    } catch (e) {
      debugPrint('SchoolRepository seed error: $e');
      rethrow;
    }
  }

  Future<int> count() => _schoolDao.count();

  Future<List<School>> getAll() => _schoolDao.getAll();

  Future<List<School>> search(String query) => _schoolDao.search(query);

  String _detectSchoolType(OverpassPlace place) {
    final name = place.name.toLowerCase();
    if (name.contains('chuyên') || name.contains('chuyen')) return 'specialized';
    if (name.contains('quốc tế') || name.contains('quoc te')) return 'international';
    if (name.contains('thpt') ||
        name.contains('trung học phổ thông') ||
        name.contains('trung hoc pho thong')) {
      return 'thpt';
    }
    return 'secondary';
  }

  AdministrativeUnit? _findNearestProvince(
    double lat,
    double lon,
    List<AdministrativeUnit> provinces,
  ) {
    if (provinces.isEmpty) return null;
    AdministrativeUnit? nearest;
    var bestDist = double.infinity;
    for (final p in provinces) {
      final clat = p.centroidLat;
      final clon = p.centroidLon;
      if (clat == null || clon == null) continue;
      final d = _haversineKm(lat, lon, clat, clon);
      if (d < bestDist) {
        bestDist = d;
        nearest = p;
      }
    }
    return nearest;
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);
}
