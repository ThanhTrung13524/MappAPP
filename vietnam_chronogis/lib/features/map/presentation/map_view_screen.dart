import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/population_heatmap_value.dart';
import '../../../shared/providers/map_provider.dart';
import '../../../shared/providers/tourism_provider.dart';
import '../../../shared/providers/routing_provider.dart';
import '../../../shared/providers/school_provider.dart';
import '../providers/map_geometry_providers.dart';
import 'widgets/map_controls_widget.dart';
import 'widgets/province_info_popup.dart';
import 'widgets/tourism_filter_bar.dart';
import 'widgets/tourism_place_popup.dart';
import 'widgets/map_layers.dart';
import 'widgets/routing_panel.dart';
import 'widgets/school_popup.dart';
import 'widgets/school_layer_toggle.dart';

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerStateProvider);
    final mapStyle = ref.watch(mapTileStyleStateProvider);
    final geometriesAsync = ref.watch(provinceGeometriesProvider);
    final showHeatmap = ref.watch(showHeatmapStateProvider);

    final isRoutingMode = ref.watch(isRoutingModeProvider);

    final tileUrl = mapStyle == MapTileStyle.street
        ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
        : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(16.0, 106.0),
                initialZoom: 5.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onTap: (tapPosition, point) {
                  if (ref.read(isRoutingModeProvider)) {
                    ref
                        .read(routeStartPointProvider.notifier)
                        .updatePoint(point);
                  } else {
                    final province = findProvinceAtPoint(
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
                const _ProvincePolygonLayer(),
                const TourismMarkersLayer(),
                const SchoolMarkersLayer(),
                const RoutePolylineLayer(),
                const RouteEndpointMarkersLayer(),
              ],
            ),
          ),
          const TourismEmptyOverlay(),
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

class _ProvincePolygonLayer extends ConsumerWidget {
  const _ProvincePolygonLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polygonsAsync = ref.watch(mapPolygonsProvider);

    return polygonsAsync.when(
      data: (polygons) {
        if (polygons.isEmpty) return const SizedBox.shrink();
        return PolygonLayer(polygons: polygons);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error loading polygons: $error')),
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
