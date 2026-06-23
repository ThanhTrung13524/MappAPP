import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/administrative_unit_dao.dart';
import '../../core/database/daos/geojson_dao.dart';
import 'geojson_parser.dart';

class ProvinceGeoJsonService {
  ProvinceGeoJsonService({
    required AdministrativeUnitDao unitDao,
    required GeoJsonDao geoJsonDao,
  })  : _unitDao = unitDao,
        _geoJsonDao = geoJsonDao;

  final AdministrativeUnitDao _unitDao;
  final GeoJsonDao _geoJsonDao;

  Future<void> loadAndMatchGeoJson() async {
    final featureCollection = await GeoJsonParser().parseFromAssets(
      'assets/geojson/gadm41_VNM_1.json',
    );
    final rawFeatures = featureCollection.features;
    if (rawFeatures.isEmpty) {
      debugPrint('[ProvinceGeoJsonService] No GADM province features found');
      return;
    }

    final provinces = await _unitDao.getAllProvinces();
    if (provinces.isEmpty) {
      debugPrint('[ProvinceGeoJsonService] No province rows in DB to match GADM');
      return;
    }

    final mergedByProvince = <String, List<List<List<LatLng>>>>{};
    var gadmCachedCount = 0;
    var gadmMatchedCount = 0;

    for (final feature in rawFeatures) {
      final properties = feature.properties;
      final gadmName = _firstString([
        properties['VARNAME_1'],
        properties['NAME_1'],
        properties['NL_NAME_1'],
      ]);
      if (gadmName == null || gadmName.trim().isEmpty) {
        continue;
      }

      final polygons = GeoJsonParser.extractCoordinates(feature.geometry);
      if (polygons.isEmpty) {
        continue;
      }

      final normalizedGadmName = _normalizeName(gadmName);
      await _cachePolygons('gadm_$normalizedGadmName', polygons);
      gadmCachedCount++;

      final matchedProvinces = provinces.where((province) {
        return _isProvinceMatch(province, normalizedGadmName);
      }).toList(growable: false);

      if (matchedProvinces.isEmpty) {
        debugPrint('[ProvinceGeoJsonService] Unmatched GADM feature: $gadmName -> $normalizedGadmName');
        continue;
      }

      for (final province in matchedProvinces) {
        final bucket = mergedByProvince.putIfAbsent(province.ma, () => <List<List<LatLng>>>[]);
        bucket.addAll(polygons);
        gadmMatchedCount++;
      }
    }

    var cachedProvinceCount = 0;
    for (final entry in mergedByProvince.entries) {
      await _cachePolygons(entry.key, entry.value);
      cachedProvinceCount++;
    }

    debugPrint(
      '[ProvinceGeoJsonService] GADM cached=$gadmCachedCount matchedFeatures=$gadmMatchedCount provincesCached=$cachedProvinceCount/${provinces.length}',
    );
  }

  Future<List<List<List<LatLng>>>> getPolygons(String ma) async {
    final cached = await _geoJsonDao.getGeoJsonByMa(ma);
    if (cached == null || cached.geoJsonData.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(cached.geoJsonData) as List<dynamic>;
      return decoded.map((polygon) {
        return (polygon as List<dynamic>).map((ring) {
          return (ring as List<dynamic>).map((point) {
            final pair = point as List<dynamic>;
            if (pair.length < 2) {
              return const LatLng(0, 0);
            }
            final lat = (pair[0] as num).toDouble();
            final lon = (pair[1] as num).toDouble();
            return LatLng(lat, lon);
          }).where((point) => point.latitude != 0 || point.longitude != 0).toList(growable: false);
        }).where((ring) => ring.length >= 3).toList(growable: false);
      }).where((polygon) => polygon.isNotEmpty).toList(growable: false);
    } catch (error) {
      debugPrint('[ProvinceGeoJsonService] Failed to decode cached GeoJSON for $ma: $error');
      return const [];
    }
  }

  Future<void> _cachePolygons(String ma, List<List<List<LatLng>>> polygons) async {
    final coordinatesJson = jsonEncode(
      polygons.map((polygon) {
        return polygon.map((ring) {
          return ring.map((point) => [point.latitude, point.longitude]).toList(growable: false);
        }).toList(growable: false);
      }).toList(growable: false),
    );

    await _geoJsonDao.cacheGeoJson(ma, coordinatesJson);
  }

  bool _isProvinceMatch(AdministrativeUnit province, String normalizedGadmName) {
    final candidates = <String>{};
    void addCandidate(String? value) {
      if (value == null || value.trim().isEmpty) return;
      for (final part in _splitCompositeNames(value)) {
        final normalized = _normalizeName(part);
        if (normalized.isNotEmpty) candidates.add(normalized);
      }
    }

    addCandidate(province.ten);
    addCandidate(province.tenShort);
    addCandidate(province.capital);
    addCandidate(province.parentTen);
    addCandidate(province.predecessors);
    for (final predecessor in province.predecessorsList) {
      addCandidate(predecessor);
    }
    for (final keyword in province.keywords) {
      addCandidate(keyword);
    }

    if (candidates.contains(normalizedGadmName)) {
      return true;
    }

    return candidates.any((candidate) {
      if (candidate.length < 4 || normalizedGadmName.length < 4) {
        return false;
      }
      return candidate.contains(normalizedGadmName) || normalizedGadmName.contains(candidate);
    });
  }

  List<String> _splitCompositeNames(String value) {
    return value
        .replaceAll(RegExp(r'\([^)]*\)'), ' ')
        .split(RegExp(r'[,;/+]|\bva\b|\bvà\b|\bvà\b', caseSensitive: false))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  String _normalizeName(String value) {
    var normalized = _removeDiacritics(value).toLowerCase();
    normalized = normalized
        .replaceAll(RegExp(r'\([^)]*\)'), ' ')
        .replaceAll(RegExp(r'\b(tinh|thanh pho|thu do|tp|tp\.)\b'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
    return normalized;
  }

  String _removeDiacritics(String value) {
    const replacements = <String, String>{
      'á': 'a', 'à': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'ă': 'a', 'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'â': 'a', 'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      'é': 'e', 'è': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      'í': 'i', 'ì': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      'ó': 'o', 'ò': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ố': 'o', 'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      'ú': 'u', 'ù': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ứ': 'u', 'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      'ý': 'y', 'ỳ': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      'đ': 'd',
      'Á': 'A', 'À': 'A', 'Ả': 'A', 'Ã': 'A', 'Ạ': 'A',
      'Ă': 'A', 'Ắ': 'A', 'Ằ': 'A', 'Ẳ': 'A', 'Ẵ': 'A', 'Ặ': 'A',
      'Â': 'A', 'Ấ': 'A', 'Ầ': 'A', 'Ẩ': 'A', 'Ẫ': 'A', 'Ậ': 'A',
      'É': 'E', 'È': 'E', 'Ẻ': 'E', 'Ẽ': 'E', 'Ẹ': 'E',
      'Ê': 'E', 'Ế': 'E', 'Ề': 'E', 'Ể': 'E', 'Ễ': 'E', 'Ệ': 'E',
      'Í': 'I', 'Ì': 'I', 'Ỉ': 'I', 'Ĩ': 'I', 'Ị': 'I',
      'Ó': 'O', 'Ò': 'O', 'Ỏ': 'O', 'Õ': 'O', 'Ọ': 'O',
      'Ô': 'O', 'Ố': 'O', 'Ồ': 'O', 'Ổ': 'O', 'Ỗ': 'O', 'Ộ': 'O',
      'Ơ': 'O', 'Ớ': 'O', 'Ờ': 'O', 'Ở': 'O', 'Ỡ': 'O', 'Ợ': 'O',
      'Ú': 'U', 'Ù': 'U', 'Ủ': 'U', 'Ũ': 'U', 'Ụ': 'U',
      'Ư': 'U', 'Ứ': 'U', 'Ừ': 'U', 'Ử': 'U', 'Ữ': 'U', 'Ự': 'U',
      'Ý': 'Y', 'Ỳ': 'Y', 'Ỷ': 'Y', 'Ỹ': 'Y', 'Ỵ': 'Y',
      'Đ': 'D',
    };

    final buffer = StringBuffer();
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(replacements[char] ?? char);
    }
    return buffer.toString();
  }

  String? _firstString(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
