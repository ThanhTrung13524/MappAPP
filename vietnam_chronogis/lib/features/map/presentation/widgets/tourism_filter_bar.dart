// lib/features/map/presentation/widgets/tourism_filter_bar.dart
//
// Filter bar nằm góc trên-trái bản đồ.
// Cho phép toggle từng loại POI và bật/tắt toàn bộ tourism layer.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/tourism_provider.dart';
import '../../../../shared/providers/seed_provider.dart';

class TourismFilterBar extends ConsumerWidget {
  const TourismFilterBar({super.key});

  static const _categories = [
    ('worldHeritage', 'UNESCO'),
    ('attraction', 'Sights'),
    ('museum', 'Museum'),
    ('temple', 'Temple'),
    ('ruins', 'Ruins'),
    ('viewpoint', 'Views'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(showTourismLayerProvider);
    final active = ref.watch(tourismFilterProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Master toggle + Sync Button ────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => ref.read(showTourismLayerProvider.notifier).toggle(),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        show ? Icons.layers : Icons.layers_clear,
                        color: show ? const Color(0xFF2D5A8E) : Colors.white38,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LANDMARKS',
                        style: TextStyle(
                          color: show ? Colors.white : Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Mini toggle switch
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28,
                        height: 14,
                        decoration: BoxDecoration(
                          color: show
                              ? const Color(0xFF2D5A8E)
                              : Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: show
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (show) ...[
                const SizedBox(width: 12),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.sync, color: Colors.white54, size: 14),
                  tooltip: 'Tải lại dữ liệu du lịch',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1D23),
                        title: const Text('Tải lại dữ liệu', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Bạn có chắc chắn muốn tải lại toàn bộ dữ liệu địa điểm du lịch từ OpenStreetMap? Quá trình này có thể mất 1-2 phút.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Hủy', style: TextStyle(color: Colors.white38)),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Đồng ý', style: TextStyle(color: Color(0xFF2D5A8E))),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('seeded_v4');
                      ref.invalidate(seedInitializationProvider);
                      if (context.mounted) {
                        context.go('/seed');
                      }
                    }
                  },
                ),
              ],
            ],
          ),

          if (show) ...[
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.white12),
            const SizedBox(height: 8),

            // ── Category chips ────────────────────────────
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _categories.map((entry) {
                final (cat, shortLabel) = entry;
                final isOn = active.contains(cat);
                final color = tourismCategoryColor(cat);
                final icon = tourismCategoryIcon(cat);

                return GestureDetector(
                  onTap: () => ref
                      .read(tourismFilterProvider.notifier)
                      .toggleCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOn
                          ? color.withValues(alpha: 0.22)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOn
                            ? color.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 11,
                          color: isOn ? color : Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shortLabel,
                          style: TextStyle(
                            color: isOn ? color : Colors.white38,
                            fontSize: 10,
                            fontWeight: isOn
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
