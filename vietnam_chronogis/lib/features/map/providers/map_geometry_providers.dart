import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/database/app_database.dart';
import '../../../data/geojson/vietnam_geo_validator.dart';
import '../../../shared/models/population_heatmap_value.dart';
import '../../../shared/providers/api_provider.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/geojson_provider.dart';
import '../../../shared/providers/map_provider.dart';
import '../domain/province_geometry.dart';

final provinceGeometriesProvider = FutureProvider<List<ProvinceGeometry>>((
  ref,
) async {
  final unitDao = ref.watch(administrativeUnitDaoProvider);
  final geoJsonDao = ref.watch(geoJsonDaoProvider);
  final geoService = ref.watch(provinceGeoJsonServiceProvider);
  final hfClient = ref.watch(huggingFaceApiClientProvider);

  var provinces = await unitDao.getAllProvinces();
  if (provinces.isEmpty) {
    debugPrint(
      'ProvinceGeometries: DB has 0 provinces; using HuggingFace runtime fallback',
    );
    final hfRows = await hfClient.fetchAll(config: 'provinces');
    provinces = hfRows.map((row) {
      return AdministrativeUnit(
        id: row.id,
        kind: row.kind,
        ma: row.ma,
        ten: row.ten,
        type: row.type,
        tenShort: row.tenShort,
        areaKm2: row.areaKm2,
        population: row.population,
        density: row.density,
        capital: row.capital,
        address: row.address,
        phone: row.phone,
        decree: row.decree,
        decreeUrl: row.decreeUrl,
        predecessors: row.predecessors,
        parentMa: row.parentMa,
        parentTen: row.parentTen,
        centroidLon: row.centroidLon,
        centroidLat: row.centroidLat,
        bbox: row.bbox,
        geomType: row.geomType,
        nVertices: row.nVertices,
        macroRegion: row.macroRegion,
        predecessorsList: row.predecessorsList,
        nPredecessors: row.nPredecessors,
        embedText: row.embedText,
        keywords: row.keywords,
        parentTenXa: row.parentTenXa,
      );
    }).toList();
  }

  Future<List<ProvinceGeometry>> loadGeometries() async {
    final results = <ProvinceGeometry>[];
    var cacheHits = 0;

    for (final province in provinces) {
      final cached = await geoJsonDao.getGeoJsonByMa(province.ma);
      if (cached == null) continue;

      cacheHits++;
      try {
        final polyPoints = VietnamGeoValidator.decodeCachedPolygons(
          cached.geoJsonData,
        );
        if (polyPoints.isNotEmpty) {
          results.add(ProvinceGeometry(province, polyPoints));
        }
      } catch (error) {
        debugPrint('Error parsing polygon for ${province.ma}: $error');
      }
    }

    debugPrint(
      'ProvinceGeometries: mapped ${results.length}/${provinces.length} provinces, cacheHits=$cacheHits',
    );
    return results;
  }

  var results = await loadGeometries();
  if (results.isEmpty && provinces.isNotEmpty) {
    debugPrint('ProvinceGeometries: using asset-based GeoJSON fallback');
    await geoService.loadAndMatchGeoJson();
    results = await loadGeometries();
  }

  return results;
});

final heatmapStatsProvider = Provider<AsyncValue<HeatmapStats>>((ref) {
  final geometriesAsync = ref.watch(provinceGeometriesProvider);
  final heatmapValuesAsync = ref.watch(heatmapValuesProvider);

  if (geometriesAsync.isLoading || heatmapValuesAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (geometriesAsync.hasError) {
    return AsyncValue.error(
      geometriesAsync.error!,
      geometriesAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (heatmapValuesAsync.hasError) {
    return AsyncValue.error(
      heatmapValuesAsync.error!,
      heatmapValuesAsync.stackTrace ?? StackTrace.current,
    );
  }

  final geometries = geometriesAsync.value ?? const <ProvinceGeometry>[];
  final values =
      heatmapValuesAsync.value ?? const <String, PopulationHeatmapValue>{};
  final valueList = values.values.toList();
  final densities = valueList.map((value) => value.density).toList();

  return AsyncValue.data(
    HeatmapStats(
      provinceCount: geometries.length,
      valueCount: valueList.length,
      minDensity: densities.isEmpty
          ? 0
          : densities.reduce((a, b) => a < b ? a : b),
      maxDensity: densities.isEmpty
          ? 0
          : densities.reduce((a, b) => a > b ? a : b),
    ),
  );
});

final heatmapValuesProvider =
    FutureProvider<Map<String, PopulationHeatmapValue>>((ref) async {
      final geometries = await ref.watch(provinceGeometriesProvider.future);
      final values = <String, PopulationHeatmapValue>{};

      for (final geometry in geometries) {
        final value = _heatmapValueForProvince(geometry.province);
        if (value != null) {
          values[geometry.province.ma] = value;
        }
      }

      if (values.isNotEmpty) return values;

      debugPrint('Heatmap: DB has no density; fetching HuggingFace fallback.');
      final hfClient = ref.watch(huggingFaceApiClientProvider);
      final rows = await hfClient.fetchAll(config: 'provinces');
      final rowsByCode = {
        for (final row in rows)
          if (row.density != null && row.density! > 0) row.ma: row,
      };
      final rowsByName = {
        for (final row in rows)
          if (row.density != null && row.density! > 0)
            _normalizeHeatmapName(row.tenShort): row,
      };

      for (final geometry in geometries) {
        final province = geometry.province;
        final row =
            rowsByCode[province.ma] ??
            rowsByName[_normalizeHeatmapName(province.tenShort)] ??
            rowsByName[_normalizeHeatmapName(province.ten)];
        if (row == null) continue;

        values[province.ma] = PopulationHeatmapValue(
          provinceCode: province.ma,
          population: row.population ?? row.density ?? 0,
          areaKm2: row.areaKm2 ?? 1,
          densityOverride: row.density,
        );
      }

      debugPrint(
        'Heatmap: HuggingFace fallback mapped ${values.length} provinces.',
      );
      return values;
    });

final mapPolygonsProvider = Provider<AsyncValue<List<Polygon>>>((ref) {
  final geometriesAsync = ref.watch(provinceGeometriesProvider);
  final heatmapValuesAsync = ref.watch(heatmapValuesProvider);
  final showBorders = ref.watch(showBordersStateProvider);
  final showHeatmap = ref.watch(showHeatmapStateProvider);
  final selectedMa = ref.watch(selectedProvinceProvider);

  if (!showHeatmap) return const AsyncValue.data(<Polygon>[]);

  if (heatmapValuesAsync.isLoading) return const AsyncValue.loading();
  if (heatmapValuesAsync.hasError) {
    return AsyncValue.error(
      heatmapValuesAsync.error!,
      heatmapValuesAsync.stackTrace ?? StackTrace.current,
    );
  }

  return geometriesAsync.whenData((geometries) {
    final heatmapValues =
        heatmapValuesAsync.value ?? const <String, PopulationHeatmapValue>{};
    final densities = heatmapValues.values.map((value) => value.density);
    final minDensity = densities.isEmpty
        ? 0.0
        : densities.reduce((a, b) => a < b ? a : b);
    final maxDensity = densities.isEmpty
        ? 0.0
        : densities.reduce((a, b) => a > b ? a : b);

    final polygons = <Polygon>[];
    for (final geom in geometries) {
      final province = geom.province;
      final isSelected = selectedMa == province.ma;
      final heatmapValue = heatmapValues[province.ma];
      final baseColor = _getHeatmapColorForValue(
        heatmapValue,
        minDensity: minDensity,
        maxDensity: maxDensity,
      );
      final fillColor = isSelected
          ? baseColor.withValues(alpha: 0.95)
          : baseColor;
      final borderColor = isSelected
          ? Colors.white
          : Colors.white.withValues(alpha: 0.4);
      final borderThickness = isSelected ? 2.0 : (showBorders ? 1.0 : 0.0);

      for (final polygon in geom.polygons) {
        polygons.add(
          Polygon(
            points: polygon.first,
            holePointsList: polygon.length > 1
                ? polygon.skip(1).toList()
                : null,
            color: fillColor,
            borderColor: borderColor,
            borderStrokeWidth: borderThickness,
          ),
        );
      }
    }
    return polygons;
  });
});

AdministrativeUnit? findProvinceAtPoint(
  LatLng point,
  List<ProvinceGeometry> geometries,
) {
  for (final geometry in geometries.reversed) {
    for (final polygon in geometry.polygons) {
      if (VietnamGeoValidator.containsPoint(point, polygon)) {
        return geometry.province;
      }
    }
  }
  return null;
}

PopulationHeatmapValue? _heatmapValueForProvince(AdministrativeUnit province) {
  final explicitDensity = province.density;
  if (explicitDensity != null && explicitDensity > 0) {
    return PopulationHeatmapValue(
      provinceCode: province.ma,
      population: province.population ?? explicitDensity,
      areaKm2: province.areaKm2 ?? 1,
      densityOverride: explicitDensity,
    );
  }

  final population = province.population;
  final areaKm2 = province.areaKm2;
  if (population != null && population > 0 && areaKm2 != null && areaKm2 > 0) {
    return PopulationHeatmapValue(
      provinceCode: province.ma,
      population: population,
      areaKm2: areaKm2,
    );
  }

  return null;
}

Color _getHeatmapColorForValue(
  PopulationHeatmapValue? value, {
  required double minDensity,
  required double maxDensity,
}) {
  if (value == null || value.density <= 0) {
    return const Color(0xFFE5E5E5).withValues(alpha: 0.45);
  }
  final normalized = normalizeDensity(
    value: value.density,
    min: minDensity,
    max: maxDensity,
  );
  return heatmapColor(normalized);
}

String _normalizeHeatmapName(String input) {
  var value = _removeVietnameseDiacritics(input).toLowerCase();
  value = value
      .replaceAll(RegExp(r'\([^)]*\)'), ' ')
      .replaceAll(RegExp(r'\b(tinh|thanh pho|thu do|tp|tp\.)\b'), ' ')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '');
  return value;
}

String _removeVietnameseDiacritics(String value) {
  const replacements = <String, String>{
    'á': 'a',
    'à': 'a',
    'ả': 'a',
    'ã': 'a',
    'ạ': 'a',
    'ă': 'a',
    'ắ': 'a',
    'ằ': 'a',
    'ẳ': 'a',
    'ẵ': 'a',
    'ặ': 'a',
    'â': 'a',
    'ấ': 'a',
    'ầ': 'a',
    'ẩ': 'a',
    'ẫ': 'a',
    'ậ': 'a',
    'é': 'e',
    'è': 'e',
    'ẻ': 'e',
    'ẽ': 'e',
    'ẹ': 'e',
    'ê': 'e',
    'ế': 'e',
    'ề': 'e',
    'ể': 'e',
    'ễ': 'e',
    'ệ': 'e',
    'í': 'i',
    'ì': 'i',
    'ỉ': 'i',
    'ĩ': 'i',
    'ị': 'i',
    'ó': 'o',
    'ò': 'o',
    'ỏ': 'o',
    'õ': 'o',
    'ọ': 'o',
    'ô': 'o',
    'ố': 'o',
    'ồ': 'o',
    'ổ': 'o',
    'ỗ': 'o',
    'ộ': 'o',
    'ơ': 'o',
    'ớ': 'o',
    'ờ': 'o',
    'ở': 'o',
    'ỡ': 'o',
    'ợ': 'o',
    'ú': 'u',
    'ù': 'u',
    'ủ': 'u',
    'ũ': 'u',
    'ụ': 'u',
    'ư': 'u',
    'ứ': 'u',
    'ừ': 'u',
    'ử': 'u',
    'ữ': 'u',
    'ự': 'u',
    'ý': 'y',
    'ỳ': 'y',
    'ỷ': 'y',
    'ỹ': 'y',
    'ỵ': 'y',
    'đ': 'd',
  };

  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(replacements[char] ?? char);
  }
  return buffer.toString();
}
