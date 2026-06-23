// lib/features/explorer/presentation/widgets/explorer_filter_bar.dart
// FIX: xoá unused import tourism_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../explorer_screen.dart';

class ExplorerFilterBar extends ConsumerWidget {
  final TextEditingController searchController;

  const ExplorerFilterBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(explorerSearchProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D23),
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF12151C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search landmarks...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                  suffixIcon: search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white38, size: 16),
                          onPressed: () {
                            searchController.clear();
                            ref.read(explorerSearchProvider.notifier).set('');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (v) =>
                    ref.read(explorerSearchProvider.notifier).set(v),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _BarButton(icon: Icons.sort, label: 'Sort', onTap: () {}),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 16),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}