import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// FIX: import DAO providers trÃƒÂ¡Ã‚Â»Ã‚Â±c tiÃƒÂ¡Ã‚ÂºÃ‚Â¿p thay vÃƒÆ’Ã‚Â¬ repository
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/geojson_provider.dart';
import '../../../shared/providers/map_provider.dart';
import '../../../shared/providers/tourism_provider.dart';
import '../../../shared/providers/api_provider.dart';
import '../../../shared/models/population_heatmap_value.dart';
import '../../../data/geojson/vietnam_geo_validator.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/providers/routing_provider.dart';
import 'widgets/map_controls_widget.dart';
import 'widgets/province_info_popup.dart';
import 'widgets/tourism_filter_bar.dart';
import 'widgets/tourism_place_popup.dart';
import '../../../shared/providers/school_provider.dart';
import 'widgets/routing_panel.dart';
import 'widgets/school_popup.dart';
import 'widgets/school_layer_toggle.dart';

class ProvinceGeometry {
  final AdministrativeUnit province;
  final List<List<List<LatLng>>> polygons;
  ProvinceGeometry(this.province, this.polygons);
}

class HeatmapStats {
  final int provinceCount;
  final int valueCount;
  final double minDensity;
  final double maxDensity;

  const HeatmapStats({
    required this.provinceCount,
    required this.valueCount,
    required this.minDensity,
    required this.maxDensity,
  });

  bool get hasValues => valueCount > 0;
}

final provinceGeometriesProvider = FutureProvider<List<ProvinceGeometry>>((
  ref,
) async {
  final unitDao = ref.watch(administrativeUnitDaoProvider);
  final geoJsonDao = ref.watch(geoJsonDaoProvider);
  final geoService = ref.watch(provinceGeoJsonServiceProvider);
  final hfClient = ref.watch(huggingFaceApiClientProvider);

  var provinces = await unitDao.getAllProvinces();
  if (provinces.isEmpty) {
    debugPrint('ProvinceGeometries: DB has 0 provinces; using HuggingFace runtime fallback');
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
  debugPrint(
    'ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â [ProvinceGeometries] Loading ${provinces.length} provinces...',
  );

  Future<List<ProvinceGeometry>> loadGeometries() async {
    final List<ProvinceGeometry> results = [];
    int cacheHits = 0;

    for (final province in provinces) {
      debugPrint(
        '  ÃƒÂ°Ã…Â¸Ã¢â‚¬Å“Ã‚Â ${province.ten}: density=${province.density}, macroRegion=${province.macroRegion}',
      );

      final cached = await geoJsonDao.getGeoJsonByMa(province.ma);
      if (cached == null) {
        debugPrint('  ÃƒÂ¢Ã…Â¡Ã‚Â ÃƒÂ¯Ã‚Â¸Ã‚Â [ProvinceGeometries] cache miss for ${province.ma}');
        continue;
      }

      cacheHits++;
      try {
        final polyPoints = VietnamGeoValidator.decodeCachedPolygons(
          cached.geoJsonData,
        );
        if (polyPoints.isNotEmpty) {
          results.add(ProvinceGeometry(province, polyPoints));
        }
      } catch (e) {
        debugPrint('Error parsing polygon for ${province.ma}: $e');
      }
    }

    debugPrint(
      'ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â [ProvinceGeometries] mapped ${results.length}/${provinces.length} provinces, cacheHits=$cacheHits',
    );
    return results;
  }

  var results = await loadGeometries();
  if (results.isEmpty && provinces.isNotEmpty) {
    debugPrint(
      'ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â [ProvinceGeometries] falling back to asset-based geojson load',
    );
    await geoService.loadAndMatchGeoJson();
    results = await loadGeometries();
  }

  return results;
});

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
  final values = heatmapValuesAsync.value ?? const <String, PopulationHeatmapValue>{};

  return AsyncValue.data(() {
    final valueList = values.values.toList();
    final densities = valueList.map((value) => value.density).toList();
    return HeatmapStats(
      provinceCount: geometries.length,
      valueCount: valueList.length,
      minDensity: densities.isEmpty
          ? 0
          : densities.reduce((a, b) => a < b ? a : b),
      maxDensity: densities.isEmpty
          ? 0
          : densities.reduce((a, b) => a > b ? a : b),
    );
  }());
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
    final row = rowsByCode[province.ma] ??
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

  debugPrint('Heatmap: HuggingFace fallback mapped ${values.length} provinces.');
  return values;
});

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
    'ÃƒÂ¡': 'a', 'ÃƒÂ ': 'a', 'Ã¡ÂºÂ£': 'a', 'ÃƒÂ£': 'a', 'Ã¡ÂºÂ¡': 'a',
    'Ã„Æ’': 'a', 'Ã¡ÂºÂ¯': 'a', 'Ã¡ÂºÂ±': 'a', 'Ã¡ÂºÂ³': 'a', 'Ã¡ÂºÂµ': 'a', 'Ã¡ÂºÂ·': 'a',
    'ÃƒÂ¢': 'a', 'Ã¡ÂºÂ¥': 'a', 'Ã¡ÂºÂ§': 'a', 'Ã¡ÂºÂ©': 'a', 'Ã¡ÂºÂ«': 'a', 'Ã¡ÂºÂ­': 'a',
    'ÃƒÂ©': 'e', 'ÃƒÂ¨': 'e', 'Ã¡ÂºÂ»': 'e', 'Ã¡ÂºÂ½': 'e', 'Ã¡ÂºÂ¹': 'e',
    'ÃƒÂª': 'e', 'Ã¡ÂºÂ¿': 'e', 'Ã¡Â»Â': 'e', 'Ã¡Â»Æ’': 'e', 'Ã¡Â»â€¦': 'e', 'Ã¡Â»â€¡': 'e',
    'ÃƒÂ­': 'i', 'ÃƒÂ¬': 'i', 'Ã¡Â»â€°': 'i', 'Ã„Â©': 'i', 'Ã¡Â»â€¹': 'i',
    'ÃƒÂ³': 'o', 'ÃƒÂ²': 'o', 'Ã¡Â»Â': 'o', 'ÃƒÂµ': 'o', 'Ã¡Â»Â': 'o',
    'ÃƒÂ´': 'o', 'Ã¡Â»â€˜': 'o', 'Ã¡Â»â€œ': 'o', 'Ã¡Â»â€¢': 'o', 'Ã¡Â»â€”': 'o', 'Ã¡Â»â„¢': 'o',
    'Ã†Â¡': 'o', 'Ã¡Â»â€º': 'o', 'Ã¡Â»Â': 'o', 'Ã¡Â»Å¸': 'o', 'Ã¡Â»Â¡': 'o', 'Ã¡Â»Â£': 'o',
    'ÃƒÂº': 'u', 'ÃƒÂ¹': 'u', 'Ã¡Â»Â§': 'u', 'Ã…Â©': 'u', 'Ã¡Â»Â¥': 'u',
    'Ã†Â°': 'u', 'Ã¡Â»Â©': 'u', 'Ã¡Â»Â«': 'u', 'Ã¡Â»Â­': 'u', 'Ã¡Â»Â¯': 'u', 'Ã¡Â»Â±': 'u',
    'ÃƒÂ½': 'y', 'Ã¡Â»Â³': 'y', 'Ã¡Â»Â·': 'y', 'Ã¡Â»Â¹': 'y', 'Ã¡Â»Âµ': 'y',
    'Ã„â€˜': 'd',
    'ÃƒÂ': 'A', 'Ãƒâ‚¬': 'A', 'Ã¡ÂºÂ¢': 'A', 'ÃƒÆ’': 'A', 'Ã¡ÂºÂ ': 'A',
    'Ã„â€š': 'A', 'Ã¡ÂºÂ®': 'A', 'Ã¡ÂºÂ°': 'A', 'Ã¡ÂºÂ²': 'A', 'Ã¡ÂºÂ´': 'A', 'Ã¡ÂºÂ¶': 'A',
    'Ãƒâ€š': 'A', 'Ã¡ÂºÂ¤': 'A', 'Ã¡ÂºÂ¦': 'A', 'Ã¡ÂºÂ¨': 'A', 'Ã¡ÂºÂª': 'A', 'Ã¡ÂºÂ¬': 'A',
    'Ãƒâ€°': 'E', 'ÃƒË†': 'E', 'Ã¡ÂºÂº': 'E', 'Ã¡ÂºÂ¼': 'E', 'Ã¡ÂºÂ¸': 'E',
    'ÃƒÅ ': 'E', 'Ã¡ÂºÂ¾': 'E', 'Ã¡Â»â‚¬': 'E', 'Ã¡Â»â€š': 'E', 'Ã¡Â»â€ž': 'E', 'Ã¡Â»â€ ': 'E',
    'ÃƒÂ': 'I', 'ÃƒÅ’': 'I', 'Ã¡Â»Ë†': 'I', 'Ã„Â¨': 'I', 'Ã¡Â»Å ': 'I',
    'Ãƒâ€œ': 'O', 'Ãƒâ€™': 'O', 'Ã¡Â»Å½': 'O', 'Ãƒâ€¢': 'O', 'Ã¡Â»Å’': 'O',
    'Ãƒâ€': 'O', 'Ã¡Â»Â': 'O', 'Ã¡Â»â€™': 'O', 'Ã¡Â»â€': 'O', 'Ã¡Â»â€“': 'O', 'Ã¡Â»Ëœ': 'O',
    'Ã†Â ': 'O', 'Ã¡Â»Å¡': 'O', 'Ã¡Â»Å“': 'O', 'Ã¡Â»Å¾': 'O', 'Ã¡Â»Â ': 'O', 'Ã¡Â»Â¢': 'O',
    'ÃƒÅ¡': 'U', 'Ãƒâ„¢': 'U', 'Ã¡Â»Â¦': 'U', 'Ã…Â¨': 'U', 'Ã¡Â»Â¤': 'U',
    'Ã†Â¯': 'U', 'Ã¡Â»Â¨': 'U', 'Ã¡Â»Âª': 'U', 'Ã¡Â»Â¬': 'U', 'Ã¡Â»Â®': 'U', 'Ã¡Â»Â°': 'U',
    'ÃƒÂ': 'Y', 'Ã¡Â»Â²': 'Y', 'Ã¡Â»Â¶': 'Y', 'Ã¡Â»Â¸': 'Y', 'Ã¡Â»Â´': 'Y',
    'Ã„Â': 'D',
  };

  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(replacements[char] ?? char);
  }
  return buffer.toString();
}

final mapPolygonsProvider = Provider<AsyncValue<List<Polygon>>>((ref) {
  final geometriesAsync = ref.watch(provinceGeometriesProvider);
  final heatmapValuesAsync = ref.watch(heatmapValuesProvider);
  final showBorders = ref.watch(showBordersStateProvider);
  final showHeatmap = ref.watch(showHeatmapStateProvider);
  final selectedMa = ref.watch(selectedProvinceProvider);

  if (!showHeatmap) {
    return const AsyncValue.data(<Polygon>[]);
  }

  if (showHeatmap && heatmapValuesAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (showHeatmap && heatmapValuesAsync.hasError) {
    return AsyncValue.error(
      heatmapValuesAsync.error!,
      heatmapValuesAsync.stackTrace ?? StackTrace.current,
    );
  }

  return geometriesAsync.whenData((geometries) {
    debugPrint(
      'ÃƒÂ°Ã…Â¸Ã¢â‚¬â€Ã‚ÂºÃƒÂ¯Ã‚Â¸Ã‚Â [MapPolygons] showHeatmap=$showHeatmap, provinces=${geometries.length}',
    );

    final heatmapValues = heatmapValuesAsync.value ??
        const <String, PopulationHeatmapValue>{};

    final densities = heatmapValues.values.map((value) => value.density);
    final minDensity = densities.isEmpty
        ? 0.0
        : densities.reduce((a, b) => a < b ? a : b);
    final maxDensity = densities.isEmpty
        ? 0.0
        : densities.reduce((a, b) => a > b ? a : b);

    final List<Polygon> polygons = [];
    for (final geom in geometries) {
      final province = geom.province;
      final isSelected = selectedMa == province.ma;
      final heatmapValue = heatmapValues[province.ma];

      final baseColor = _getHeatmapColorForValue(
        heatmapValue,
        minDensity: minDensity,
        maxDensity: maxDensity,
      );

      if (showHeatmap) {
        debugPrint(
          '  ÃƒÂ°Ã…Â¸Ã¢â‚¬Å“Ã‚Â ${province.ten}: density=${province.density} ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ color=${baseColor.toARGB32().toRadixString(16)}',
        );
      }

      final fillColor = isSelected ? baseColor.withValues(alpha: 0.95) : baseColor;
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

AdministrativeUnit? _findProvinceAtPoint(
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

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerStateProvider);
    final mapStyle = ref.watch(mapTileStyleStateProvider);
    final polygonsAsync = ref.watch(mapPolygonsProvider);
    final geometriesAsync = ref.watch(provinceGeometriesProvider);
    final tourismMarkersAsync = ref.watch(tourismMarkersProvider);
    final schoolMarkersAsync = ref.watch(schoolMarkersProvider);
    final tourismPlacesCountAsync = ref.watch(tourismPlacesCountProvider);
    final showTourism = ref.watch(showTourismLayerProvider);
    final showHeatmap = ref.watch(showHeatmapStateProvider);
    final activeTourismCategories = ref.watch(tourismFilterProvider);

    final isRoutingMode = ref.watch(isRoutingModeProvider);
    final routeDataAsync = ref.watch(routeDataProvider);
    final startPoint = ref.watch(routeStartPointProvider);
    final endPoint = ref.watch(routeEndPointProvider);

    final tileUrl = mapStyle == MapTileStyle.street
        ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
        : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(16.0, 106.0),
              initialZoom: 5.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (tapPosition, point) {
                if (ref.read(isRoutingModeProvider)) {
                  ref.read(routeStartPointProvider.notifier).updatePoint(point);
                } else {
                  final province = _findProvinceAtPoint(
                    point,
                    geometriesAsync.value ?? const [],
                  );
                  if (province != null) {
                    ref
                        .read(selectedProvinceProvider.notifier)
                        .select(province.ma);
                  } else {
                    ref.read(selectedProvinceProvider.notifier).clear();
                  }
                  ref.read(selectedTourismPlaceProvider.notifier).clear();
                  ref.read(selectedSchoolProvider.notifier).clear();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.example.vietnam_chronogis',
              ),
              polygonsAsync.when(
                data: (polygons) {
                  if (polygons.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return PolygonLayer(polygons: polygons);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) =>
                    Center(child: Text('Error loading polygons: $e')),
              ),
              // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Tourism markers layer ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
              if (!isRoutingMode)
                tourismMarkersAsync.when(
                  data: (markers) => MarkerLayer(markers: markers),
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                ),
              if (!isRoutingMode)
                schoolMarkersAsync.when(
                  data: (markers) => MarkerLayer(markers: markers),
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                ),

              // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Routing Polyline Layer ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
              if (isRoutingMode)
                routeDataAsync.when(
                  data: (data) {
                    if (data == null) return const SizedBox.shrink();
                    return PolylineLayer(
                      polylines: [
                        Polyline(
                          points: data.points,
                          color: const Color(0xFF1D9E75),
                          strokeWidth: 5.0,
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => const SizedBox.shrink(),
                ),

              // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Routing Markers Layer ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
              if (isRoutingMode)
                MarkerLayer(
                  markers: [
                    if (startPoint != null)
                      Marker(
                        point: startPoint,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40,
                        ),
                        alignment: Alignment.topCenter,
                      ),
                    if (endPoint != null)
                      Marker(
                        point: endPoint,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                        alignment: Alignment.topCenter,
                      ),
                  ],
                ),
            ],
          ),
          if (!isRoutingMode &&
              showTourism &&
              activeTourismCategories.isNotEmpty)
            tourismMarkersAsync.when(
              data: (markers) {
                if (markers.isNotEmpty) return const SizedBox.shrink();
                return Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: IgnorePointer(
                    child: tourismPlacesCountAsync.when(
                      data: (count) {
                        final message = count == 0
                            ? 'Chưa có dữ liệu landmarks trong cơ sở dữ liệu. Hãy tải lại dữ liệu du lịch hoặc kiểm tra lại seed.'
                            : 'Không tìm thấy điểm tham quan phù hợp category hiện tại. Hãy thử bật/tắt category hoặc tải lại dữ liệu du lịch.';
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFE24B4A).withValues(alpha: 0.7),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_outlined,
                                color: Color(0xFFE24B4A),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE24B4A).withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          children: const [
                            CircularProgressIndicator(
                              color: Color(0xFFE24B4A),
                              strokeWidth: 2,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Đang kiểm tra dữ liệu landmarks...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (e, s) => Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE24B4A).withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.error_outline, color: Color(0xFFE24B4A)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Lỗi đọc dữ liệu landmarks. Hãy thử mở lại app hoặc đồng bộ lại dữ liệu.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
          // Routing panel (top)
          const RoutingPanelWidget(),
          // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Map controls (top-right) ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
          if (!isRoutingMode)
            const Positioned(right: 24, top: 24, child: MapControlsWidget()),
          // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Tourism filter bar (top-left) ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
          if (!isRoutingMode)
            const Positioned(left: 16, top: 24, child: TourismFilterBar()),
          if (!isRoutingMode)
            const Positioned(left: 16, top: 72, child: SchoolLayerToggle()),
          if (!isRoutingMode && showHeatmap)
            const Positioned(left: 16, bottom: 24, child: _HeatmapLegend()),
          // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Province info popup (right) ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
          if (!isRoutingMode)
            const Positioned(
              right: 24,
              bottom: 164,
              child: ProvinceInfoPopup(),
            ),
          // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Tourism place popup (right-bottom) ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
          if (!isRoutingMode)
            const Positioned(right: 24, bottom: 24, child: TourismPlacePopup()),
          if (!isRoutingMode)
            const Positioned(left: 16, bottom: 24, child: SchoolPopup()),
        ],
      ),
    );
  }
}

class _HeatmapLegend extends ConsumerWidget {
  const _HeatmapLegend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    final statsAsync = ref.watch(heatmapStatsProvider);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Color(0xFFFF7043),
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Population density',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7043).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'ON',
                  style: TextStyle(
                    color: Color(0xFFFFAB91),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Row(
              children: List.generate(10, (index) {
                final t = index / 9;
                return Expanded(
                  child: Container(height: 12, color: heatmapColor(t)),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          statsAsync.when(
            data: (stats) {
              if (!stats.hasValues) {
                return const Text(
                  'Không có dữ liệu population/density trong DB. Hãy reset seed dữ liệu hành chính.',
                  style: TextStyle(
                    color: Color(0xFFFFCC80),
                    fontSize: 11,
                    height: 1.3,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatter.format(stats.minDensity),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                      const Text(
                        'người/km²',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      Text(
                        formatter.format(stats.maxDensity),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${stats.valueCount}/${stats.provinceCount} tỉnh có dữ liệu mật độ.',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Text(
              'Đang đọc dữ liệu heatmap...',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
            error: (error, stack) => const Text(
              'Không đọc được dữ liệu heatmap.',
              style: TextStyle(color: Color(0xFFE24B4A), fontSize: 11),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Màu càng đỏ nghĩa là mật độ dân số càng cao.',
            style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }
}
