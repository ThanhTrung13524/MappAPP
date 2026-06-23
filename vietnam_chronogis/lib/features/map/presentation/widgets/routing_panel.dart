import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/routing_provider.dart';

class RoutingPanelWidget extends ConsumerWidget {
  const RoutingPanelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoutingMode = ref.watch(isRoutingModeProvider);
    if (!isRoutingMode) return const SizedBox.shrink();

    final routeDataAsync = ref.watch(routeDataProvider);
    final startPoint = ref.watch(routeStartPointProvider);
    final travelMode = ref.watch(routeTravelModeProvider);

    return Positioned(
      top: 24,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D23).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon directions
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions,
                  color: Color(0xFF1D9E75),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Route Info
              Expanded(
                child: routeDataAsync.when(
                  data: (data) {
                    if (data == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            travelMode == TravelMode.driving
                                ? 'Chỉ đường ô tô'
                                : 'Chỉ đường đi bộ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: TravelMode.values.map((mode) {
                              final isSelected = travelMode == mode;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(routeTravelModeProvider.notifier)
                                        .updateMode(mode);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF1D9E75)
                                          : const Color(0xFF2A2F3E),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF1D9E75)
                                            : Colors.white24,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          mode == TravelMode.driving
                                              ? Icons.directions_car
                                              : Icons.directions_walk,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white70,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          mode.label,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            startPoint == null
                                ? 'Chạm vào bản đồ để chọn điểm bắt đầu. Hệ thống sẽ hiển thị thời gian di chuyển khi điểm đích được chọn.'
                                : 'Điểm đích đã được chọn. Chạm vào bản đồ để thay đổi điểm bắt đầu và cập nhật thời gian di chuyển.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      );
                    }

                    final distanceKm = (data.distance / 1000).toStringAsFixed(
                      1,
                    );
                    final durationMin = (data.duration / 60).round();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              travelMode == TravelMode.driving
                                  ? Icons.directions_car
                                  : Icons.directions_walk,
                              color: const Color(0xFF1D9E75),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${travelMode.label} • $durationMin phút',
                              style: const TextStyle(
                                color: Color(0xFF1D9E75),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$distanceKm km • Tuyến đường nhanh nhất',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đang tìm đường...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(color: Color(0xFF1D9E75)),
                    ],
                  ),
                  error: (e, _) => const Text(
                    'Lỗi tính đường',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Exit button
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () {
                  ref.read(isRoutingModeProvider.notifier).updateMode(false);
                  ref.read(routeStartPointProvider.notifier).updatePoint(null);
                  ref.read(routeEndPointProvider.notifier).updatePoint(null);
                },
                tooltip: 'Thoát chỉ đường',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
