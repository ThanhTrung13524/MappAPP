// lib/features/explorer/presentation/explorer_screen.dart
//
// Màn hình Explorer — duyệt danh lam thắng cảnh theo tỉnh, category, tìm kiếm.
// FIX: Thay StateProvider (removed Riverpod 3.x) → Notifier + NotifierProvider
// FIX: tourismDaoProvider ambiguous → dùng từ database_provider.dart duy nhất
// FIX: unnecessary_underscores → dùng _

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/providers/tourism_provider.dart';
import '../../../shared/providers/database_provider.dart'; // tourismDaoProvider ở đây
import 'widgets/landmark_card.dart';
import 'widgets/explorer_filter_bar.dart';
import 'widgets/landmark_detail_sheet.dart';

// ── Providers (Riverpod 3.x — Notifier) ─────────────────────

class ExplorerSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String v) => state = v;
}

final explorerSearchProvider = NotifierProvider<ExplorerSearch, String>(
  ExplorerSearch.new,
);

class ExplorerSelectedCategory extends Notifier<String?> {
  @override
  String? build() => null; // null = all
  void set(String? v) => state = v;
}

final explorerSelectedCategoryProvider =
    NotifierProvider<ExplorerSelectedCategory, String?>(
      ExplorerSelectedCategory.new,
    );

class ExplorerSelectedProvince extends Notifier<String?> {
  @override
  String? build() => null; // null = all
  void set(String? v) => state = v;
}

final explorerSelectedProvinceProvider =
    NotifierProvider<ExplorerSelectedProvince, String?>(
      ExplorerSelectedProvince.new,
    );

// ── Results provider ─────────────────────────────────────────

final explorerResultsProvider = FutureProvider<List<TourismPlace>>((ref) async {
  // FIX: chỉ dùng tourismDaoProvider từ database_provider.dart
  final dao = ref.watch(tourismDaoProvider);
  final search = ref.watch(explorerSearchProvider);
  final category = ref.watch(explorerSelectedCategoryProvider);
  final province = ref.watch(explorerSelectedProvinceProvider);

  List<TourismPlace> results;

  if (search.trim().isNotEmpty) {
    results = await dao.search(search.trim());
  } else if (province != null) {
    results = await dao.getByProvince(province);
  } else if (category != null) {
    results = await dao.getByCategory(category);
  } else {
    results = await dao.getAll();
  }

  if (category != null && search.isNotEmpty) {
    results = results.where((p) => p.category == category).toList();
  }

  return results;
});

final explorerStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final dao = ref.watch(tourismDaoProvider);
  final all = await dao.getAll();
  final stats = <String, int>{};
  for (final p in all) {
    stats[p.category] = (stats[p.category] ?? 0) + 1;
  }
  return stats;
});

// ── Screen ────────────────────────────────────────────────────

class ExplorerScreen extends ConsumerStatefulWidget {
  const ExplorerScreen({super.key});

  @override
  ConsumerState<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends ConsumerState<ExplorerScreen> {
  final _searchCtrl = TextEditingController();
  TourismPlace? _detailPlace;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(explorerResultsProvider);
    final statsAsync = ref.watch(explorerStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF12151C),
      body: Row(
        children: [
          // ── Left sidebar ──────────────────────────────────
          _LeftPanel(
            statsAsync: statsAsync,
            onProvinceSelected: (ma) {
              ref.read(explorerSelectedProvinceProvider.notifier).set(ma);
              ref.read(explorerSearchProvider.notifier).set('');
              _searchCtrl.clear();
            },
          ),

          const VerticalDivider(width: 1, color: Colors.white12),

          // ── Main content ──────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExplorerFilterBar(searchController: _searchCtrl),

                resultsAsync.when(
                  data: (list) => _ResultCountBar(count: list.length),
                  loading: () => const SizedBox(height: 32),
                  error: (_, _) => const SizedBox.shrink(),
                ),

                Expanded(
                  child: resultsAsync.when(
                    data: (places) => places.isEmpty
                        ? const _EmptyState()
                        : _LandmarkGrid(
                            places: places,
                            onTap: (p) => setState(() => _detailPlace = p),
                          ),
                    loading: () => const _GridSkeleton(),
                    error: (e, _) => Center(
                      child: Text(
                        'Error: $e',
                        style: const TextStyle(color: Color(0xFFE24B4A)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Right detail panel ────────────────────────────
          if (_detailPlace != null) ...[
            const VerticalDivider(width: 1, color: Colors.white12),
            LandmarkDetailSheet(
              place: _detailPlace!,
              onClose: () => setState(() => _detailPlace = null),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Left Panel ────────────────────────────────────────────────

class _LeftPanel extends ConsumerWidget {
  final AsyncValue<Map<String, int>> statsAsync;
  final ValueChanged<String?> onProvinceSelected;

  const _LeftPanel({
    required this.statsAsync,
    required this.onProvinceSelected,
  });

  static const _cats = [
    ('worldHeritage', 'UNESCO Heritage'),
    ('attraction', 'Attractions'),
    ('museum', 'Museums'),
    ('temple', 'Temples'),
    ('ruins', 'Historic Ruins'),
    ('viewpoint', 'Viewpoints'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(explorerSelectedCategoryProvider);

    return Container(
      width: 220,
      color: const Color(0xFF1A1D23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'BROWSE BY',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),

          _SideTile(
            label: 'All Landmarks',
            icon: Icons.public,
            isSelected: selected == null,
            count: statsAsync.value?.values.fold(0, (a, b) => (a ?? 0) + b),
            color: const Color(0xFF2D5A8E),
            onTap: () {
              ref.read(explorerSelectedCategoryProvider.notifier).set(null);
              onProvinceSelected(null);
            },
          ),

          const Divider(
            height: 1,
            color: Colors.white12,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 4),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              // FIX: unnecessary_underscores — dùng (cat, label) thay vì (cat, label)
              children: _cats.map((entry) {
                final cat = entry.$1;
                final label = entry.$2;
                final count = statsAsync.value?[cat] ?? 0;
                final color = tourismCategoryColor(cat);
                final icon = tourismCategoryIcon(cat);
                return _SideTile(
                  label: label,
                  icon: icon,
                  isSelected: selected == cat,
                  count: count,
                  color: color,
                  onTap: () {
                    ref
                        .read(explorerSelectedCategoryProvider.notifier)
                        .set(cat);
                    onProvinceSelected(null);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final int? count;
  final Color color;
  final VoidCallback onTap;

  const _SideTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: color, width: 3))
              : const Border(
                  left: BorderSide(color: Colors.transparent, width: 3),
                ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? color : Colors.white38),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if ((count ?? 0) > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? color : Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Result count bar ──────────────────────────────────────────

class _ResultCountBar extends StatelessWidget {
  final int count;
  const _ResultCountBar({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        '$count landmark${count == 1 ? '' : 's'} found',
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }
}

// ── Landmark grid ─────────────────────────────────────────────

class _LandmarkGrid extends StatelessWidget {
  final List<TourismPlace> places;
  final ValueChanged<TourismPlace> onTap;

  const _LandmarkGrid({required this.places, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 0.78,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: places.length,
      itemBuilder: (ctx, i) =>
          LandmarkCard(place: places[i], onTap: () => onTap(places[i]))
              .animate(delay: Duration(milliseconds: (i % 12) * 30))
              .fadeIn(duration: 200.ms)
              .slideY(begin: 0.06, end: 0),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 56,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          const Text(
            'No landmarks found',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Grid skeleton ─────────────────────────────────────────────

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 0.78,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: 12,
      // FIX: unnecessary_underscores → dùng _
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2128),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
