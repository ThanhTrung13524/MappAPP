import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/school_provider.dart';

class SchoolLayerToggle extends ConsumerWidget {
  const SchoolLayerToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(showSchoolsLayerProvider);

    return Material(
      color: const Color(0xFF1A1D23).withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => ref.read(showSchoolsLayerProvider.notifier).toggle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.school,
                size: 18,
                color: show ? const Color(0xFF64B5F6) : Colors.white38,
              ),
              const SizedBox(width: 6),
              Text(
                'THPT',
                style: TextStyle(
                  color: show ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
