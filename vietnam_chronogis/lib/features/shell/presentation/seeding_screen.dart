import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/seed_provider.dart';

class SeedingScreen extends ConsumerWidget {
  const SeedingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedState = ref.watch(seedInitializationProvider);
    final progress = ref.watch(seedProgressProvider);

    ref.listen(seedInitializationProvider, (previous, next) {
      if (next.value == true) {
        // Once seeding is complete, navigate to map (AppShell)
        context.go('/map');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF12151C), // dark background
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.map_outlined,
                size: 64,
                color: Color(0xFF2D5A8E),
              ),
              const SizedBox(height: 24),
              const Text(
                'Vietnam ChronoGIS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đang tải dữ liệu địa lý Vietnam...',
                style: TextStyle(
                  color: Color(0xFF9AA0B0),
                ),
              ),
              const SizedBox(height: 24),
              seedState.when(
                data: (_) => const SizedBox.shrink(),
                loading: () => Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress > 0 ? progress : null,
                      backgroundColor: const Color(0xFF1A1D23),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D5A8E)),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Color(0xFF9AA0B0),
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ],
                ),
                error: (error, stack) => Text(
                  'Error loading data: $error',
                  style: const TextStyle(color: Color(0xFFE24B4A)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
