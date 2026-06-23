import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/seed_provider.dart';

class SeedControlWidget extends ConsumerWidget {
  const SeedControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(seedProgressProvider);
    final message = ref.watch(seedMessageProvider);
    final token = ref.watch(seedCancelTokenProvider);

    final isRunning = token != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isRunning)
                  TextButton(
                    onPressed: () {
                      // Cancel running seed
                      ref.read(seedCancelTokenProvider)?.cancel();
                      ref.read(seedCancelTokenProvider.notifier).set(null);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Hủy quá trình tải dữ liệu...'),
                        ),
                      );
                    },
                    child: const Text('Hủy'),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // Retry: refresh the initialization provider
                    ref.invalidate(seedInitializationProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bắt đầu lại quá trình tải dữ liệu...'),
                      ),
                    );
                  },
                  child: const Text('Tải lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
