import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/timeline_provider.dart';
import '../../../../shared/models/timeline_era.dart';
import 'regional_profile_card.dart';

class TimelinePanel extends ConsumerWidget {
  const TimelinePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(selectedYearProvider);
    final era = ref.watch(currentEraProvider);
    final isPlaying = ref.watch(isPlayingProvider);

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () =>
                      ref.read(isPlayingProvider.notifier).toggle(),
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 40,
                    color: era.color,
                  ),
                ),
                const SizedBox(width: 16),
                const RegionalProfileCard(),
                const Spacer(),
                Expanded(
                  child: Text(
                    era.description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: era.color,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                  thumbColor: era.color,
                  // FIX: withOpacity deprecated → withValues(alpha:)
                  overlayColor: era.color.withValues(alpha: 0.2),
                  trackHeight: 4,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: year.toDouble(),
                  min: 1975,
                  max: 2025,
                  divisions: 50,
                  label: year.toString(),
                  onChanged: (value) {
                    if (ref.read(isPlayingProvider)) {
                      ref.read(isPlayingProvider.notifier).toggle();
                    }
                    ref
                        .read(selectedYearProvider.notifier)
                        .setYear(value.toInt());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}