import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/routing_provider.dart';
import '../../../../shared/providers/school_provider.dart';
import '../../../../shared/providers/tourism_provider.dart';

class TourismMarkersLayer extends ConsumerWidget {
  const TourismMarkersLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    if (isRoutingMode) return const SizedBox.shrink();

    final markersAsync = ref.watch(tourismMarkersProvider);
    return markersAsync.when(
      data: (markers) => MarkerLayer(markers: markers),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class SchoolMarkersLayer extends ConsumerWidget {
  const SchoolMarkersLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    if (isRoutingMode) return const SizedBox.shrink();

    final markersAsync = ref.watch(schoolMarkersProvider);
    return markersAsync.when(
      data: (markers) => MarkerLayer(markers: markers),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class RoutePolylineLayer extends ConsumerWidget {
  const RoutePolylineLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    if (!isRoutingMode) return const SizedBox.shrink();

    final routeDataAsync = ref.watch(routeDataProvider);
    return routeDataAsync.when(
      data: (data) {
        if (data == null) return const SizedBox.shrink();
        return PolylineLayer(
          polylines: [
            Polyline(
              points: data.points,
              color: const Color(0xFF1D9E75),
              strokeWidth: 5,
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class RouteEndpointMarkersLayer extends ConsumerWidget {
  const RouteEndpointMarkersLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    if (!isRoutingMode) return const SizedBox.shrink();

    final startPoint = ref.watch(routeStartPointProvider);
    final endPoint = ref.watch(routeEndPointProvider);
    return MarkerLayer(
      markers: [
        if (startPoint != null)
          Marker(
            point: startPoint,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
            alignment: Alignment.topCenter,
          ),
        if (endPoint != null)
          Marker(
            point: endPoint,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            alignment: Alignment.topCenter,
          ),
      ],
    );
  }
}

class TourismEmptyOverlay extends ConsumerWidget {
  const TourismEmptyOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    final showTourism = ref.watch(showTourismLayerProvider);
    final activeTourismCategories = ref.watch(tourismFilterProvider);
    if (isRoutingMode || !showTourism || activeTourismCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final markersAsync = ref.watch(tourismMarkersProvider);
    return markersAsync.when(
      data: (markers) {
        if (markers.isNotEmpty) return const SizedBox.shrink();
        return Positioned(
          top: 100,
          left: 16,
          right: 16,
          child: IgnorePointer(
            child: ref
                .watch(tourismPlacesCountProvider)
                .when(
                  data: (count) {
                    final message = count == 0
                        ? 'Chưa có dữ liệu landmarks trong cơ sở dữ liệu. Hãy tải lại dữ liệu du lịch hoặc kiểm tra lại seed.'
                        : 'Không tìm thấy điểm tham quan phù hợp category hiện tại. Hãy thử bật/tắt category hoặc tải lại dữ liệu du lịch.';
                    return _TourismStatusCard(
                      icon: Icons.warning_amber_outlined,
                      message: message,
                    );
                  },
                  loading: () => const _TourismStatusCard(
                    progress: true,
                    message: 'Đang kiểm tra dữ liệu landmarks...',
                  ),
                  error: (error, stackTrace) => const _TourismStatusCard(
                    icon: Icons.error_outline,
                    message:
                        'Lỗi đọc dữ liệu landmarks. Hãy thử mở lại app hoặc đồng bộ lại dữ liệu.',
                  ),
                ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _TourismStatusCard extends StatelessWidget {
  const _TourismStatusCard({
    required this.message,
    this.icon,
    this.progress = false,
  });

  final String message;
  final IconData? icon;
  final bool progress;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE24B4A);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          if (progress)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: accent, strokeWidth: 2),
            )
          else
            Icon(icon ?? Icons.info_outline, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
