import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../shared/providers/map_provider.dart';

class MapControlsWidget extends ConsumerWidget {
  const MapControlsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerStateProvider);
    final isSatellite =
        ref.watch(mapTileStyleStateProvider) == MapTileStyle.satellite;
    final showBorders = ref.watch(showBordersStateProvider);
    final showHeatmap = ref.watch(showHeatmapStateProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildButton(
          icon: Icons.add,
          tooltip: 'Zoom In',
          onPressed: () {
            final currentZoom = mapController.camera.zoom;
            mapController.move(mapController.camera.center, currentZoom + 1);
          },
        ),
        const SizedBox(height: 8),
        _buildButton(
          icon: Icons.remove,
          tooltip: 'Zoom Out',
          onPressed: () {
            final currentZoom = mapController.camera.zoom;
            mapController.move(mapController.camera.center, currentZoom - 1);
          },
        ),
        const SizedBox(height: 8),
        _buildButton(
          icon: Icons.crop_free,
          tooltip: 'Fit Vietnam',
          onPressed: () => mapController.move(const LatLng(16.0, 106.0), 5.5),
        ),
        const SizedBox(height: 24),
        _buildButton(
          icon: isSatellite ? Icons.map : Icons.satellite,
          tooltip: 'Toggle Map Style',
          onPressed: () =>
              ref.read(mapTileStyleStateProvider.notifier).toggle(),
        ),
        const SizedBox(height: 8),
        _buildButton(
          icon: showBorders ? Icons.grid_on : Icons.grid_off,
          tooltip: 'Toggle Borders',
          onPressed: () => ref.read(showBordersStateProvider.notifier).toggle(),
        ),
        const SizedBox(height: 8),
        _buildHeatmapButton(showHeatmap, () {
          debugPrint('Heatmap toggle clicked: $showHeatmap -> ${!showHeatmap}');
          ref.read(showHeatmapStateProvider.notifier).toggle();
        }),
      ],
    );
  }

  Widget _buildHeatmapButton(bool isActive, VoidCallback onPressed) {
    return Tooltip(
      message: 'Toggle Population Heatmap',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 132,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFF7043).withValues(alpha: 0.95)
                : const Color(0xFF1A1D23).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFFCCBC)
                  : Colors.white.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: isActive ? Colors.white : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isActive ? 'Heatmap ON' : 'Heatmap',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color iconColor = Colors.white70,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
