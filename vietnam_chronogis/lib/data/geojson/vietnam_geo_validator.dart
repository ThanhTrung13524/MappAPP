import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../../core/database/daos/administrative_unit_dao.dart';
import '../../core/database/daos/geojson_dao.dart';

const vietnamMinLat = 8.0;
const vietnamMaxLat = 23.5;
const vietnamMinLng = 102.0;
const vietnamMaxLng = 110.0;

class VietnamGeoValidator {
  final List<List<List<LatLng>>> _provincePolygons;

  const VietnamGeoValidator({
    List<List<List<LatLng>>> provincePolygons = const [],
  }) : _provincePolygons = provincePolygons;

  static Future<VietnamGeoValidator> fromCache({
    required AdministrativeUnitDao unitDao,
    required GeoJsonDao geoJsonDao,
    String fallbackAssetPath = 'assets/geojson/gadm41_VNM_1.json',
  }) async {
    final provinces = await unitDao.getAllProvinces();
    final polygons = <List<List<LatLng>>>[];

    for (final province in provinces) {
      final cached = await geoJsonDao.getGeoJsonByMa(province.ma);
      if (cached == null) continue;

      try {
        final decoded = jsonDecode(cached.geoJsonData) as List<dynamic>;
        polygons.addAll(_decodePolygons(decoded));
      } catch (e) {
        debugPrint(
          'VietnamGeoValidator: failed to parse boundary for ${province.ma}: $e',
        );
      }
    }

    if (polygons.isEmpty) {
      try {
        final assetJson = await rootBundle.loadString(fallbackAssetPath);
        polygons.addAll(_decodeGeoJsonFeatureCollection(jsonDecode(assetJson)));
        debugPrint(
          'VietnamGeoValidator: loaded ${polygons.length} boundary polygons from asset fallback',
        );
      } catch (e) {
        debugPrint(
          'VietnamGeoValidator: failed to load asset fallback boundary: $e',
        );
      }
    }

    debugPrint(
      'VietnamGeoValidator: loaded ${polygons.length} province boundary polygons',
    );
    return VietnamGeoValidator(provincePolygons: polygons);
  }

  bool get hasBoundaryData => _provincePolygons.isNotEmpty;

  bool isInsideVietnamBBox(double lat, double lng) {
    return lat >= vietnamMinLat &&
        lat <= vietnamMaxLat &&
        lng >= vietnamMinLng &&
        lng <= vietnamMaxLng;
  }

  bool isInsideVietnamBoundary(double lat, double lng) {
    if (!hasBoundaryData) return false;
    final point = LatLng(lat, lng);

    for (final polygon in _provincePolygons) {
      if (_isInsidePolygon(point, polygon)) return true;
    }

    return false;
  }

  bool isValidVietnamPoi({required double lat, required double lng}) {
    if (!isInsideVietnamBBox(lat, lng)) return false;

    if (!hasBoundaryData) return false;

    return isInsideVietnamBoundary(lat, lng);
  }

  static bool containsPoint(LatLng point, List<List<LatLng>> polygon) {
    return _isInsidePolygon(point, polygon);
  }

  static List<List<List<LatLng>>> decodeCachedPolygons(String geoJsonData) {
    final decoded = jsonDecode(geoJsonData) as List<dynamic>;
    return _decodePolygons(decoded);
  }

  static List<List<List<LatLng>>> _decodePolygons(List<dynamic> decoded) {
    return decoded
        .whereType<List<dynamic>>()
        .map((poly) {
          return poly
              .whereType<List<dynamic>>()
              .map((ring) {
                return ring
                    .whereType<List<dynamic>>()
                    .where((point) {
                      return point.length >= 2 &&
                          point[0] is num &&
                          point[1] is num;
                    })
                    .map((point) {
                      return LatLng(
                        (point[0] as num).toDouble(),
                        (point[1] as num).toDouble(),
                      );
                    })
                    .toList();
              })
              .where((ring) => ring.length >= 3)
              .toList();
        })
        .where((poly) => poly.isNotEmpty)
        .toList();
  }

  static List<List<List<LatLng>>> _decodeGeoJsonFeatureCollection(
    dynamic decoded,
  ) {
    if (decoded is! Map<String, dynamic>) return [];
    final features = decoded['features'];
    if (features is! List) return [];

    final polygons = <List<List<LatLng>>>[];
    for (final feature in features) {
      if (feature is! Map<String, dynamic>) continue;
      final geometry = feature['geometry'];
      if (geometry is! Map<String, dynamic>) continue;

      final type = geometry['type'];
      final coordinates = geometry['coordinates'];
      if (coordinates is! List) continue;

      if (type == 'Polygon') {
        final polygon = _decodeGeoJsonPolygon(coordinates);
        if (polygon.isNotEmpty) polygons.add(polygon);
      } else if (type == 'MultiPolygon') {
        for (final rawPolygon in coordinates) {
          if (rawPolygon is! List) continue;
          final polygon = _decodeGeoJsonPolygon(rawPolygon);
          if (polygon.isNotEmpty) polygons.add(polygon);
        }
      }
    }

    return polygons;
  }

  static List<List<LatLng>> _decodeGeoJsonPolygon(List<dynamic> polygon) {
    return polygon
        .whereType<List<dynamic>>()
        .map((ring) {
          return ring.whereType<List<dynamic>>().where((point) {
            return point.length >= 2 && point[0] is num && point[1] is num;
          }).map((point) {
            return LatLng(
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            );
          }).toList();
        })
        .where((ring) => ring.length >= 3)
        .toList();
  }

  static bool _isInsidePolygon(LatLng point, List<List<LatLng>> polygon) {
    if (polygon.isEmpty) return false;
    final outerRing = polygon.first;
    if (!_isInsideRing(point, outerRing)) return false;

    for (final hole in polygon.skip(1)) {
      if (_isInsideRing(point, hole)) return false;
    }

    return true;
  }

  static bool _isInsideRing(LatLng point, List<LatLng> ring) {
    if (ring.length < 3) return false;

    var inside = false;
    var previous = ring.length - 1;

    for (var current = 0; current < ring.length; current++) {
      final currentPoint = ring[current];
      final previousPoint = ring[previous];
      final intersects =
          ((currentPoint.latitude > point.latitude) !=
              (previousPoint.latitude > point.latitude)) &&
          (point.longitude <
              (previousPoint.longitude - currentPoint.longitude) *
                      (point.latitude - currentPoint.latitude) /
                      (previousPoint.latitude - currentPoint.latitude) +
                  currentPoint.longitude);

      if (intersects) inside = !inside;
      previous = current;
    }

    return inside;
  }
}
