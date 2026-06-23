// lib/features/map/presentation/widgets/tourism_place_popup.dart
// FIX: unnecessary_underscores (__, ___) → named params in callbacks

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/tourism_provider.dart';
import '../../../../data/repositories/tourism_repository.dart';
import '../../../../shared/providers/map_provider.dart';
import '../../../../shared/providers/routing_provider.dart';

class TourismPlacePopup extends ConsumerStatefulWidget {
  const TourismPlacePopup({super.key});

  @override
  ConsumerState<TourismPlacePopup> createState() => _TourismPlacePopupState();
}

class _TourismPlacePopupState extends ConsumerState<TourismPlacePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _loadingWiki = false;
  int? _lastOsmId;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _ensureWiki(TourismPlace place) async {
    if (_lastOsmId == place.osmId) return;
    if (place.wikiSummary != null || _loadingWiki) return;
    _lastOsmId = place.osmId;
    setState(() => _loadingWiki = true);
    final repo = ref.read(tourismRepositoryProvider);
    final updated = await repo.ensureWikiSummary(place);
    ref.read(selectedTourismPlaceProvider.notifier).updateWithWiki(updated);
    if (mounted) setState(() => _loadingWiki = false);
  }

  @override
  Widget build(BuildContext context) {
    final place = ref.watch(selectedTourismPlaceProvider);
    if (place == null) return const SizedBox.shrink();

    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureWiki(place));

    final color = tourismCategoryColor(place.category);
    final icon = tourismCategoryIcon(place.category);
    final label = tourismCategoryLabel(place.category);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: 320,
          constraints: const BoxConstraints(maxHeight: 530),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D23).withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(place, color, icon),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + close
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                if (place.nameEn != null &&
                                    place.nameEn != place.name) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    place.nameEn!,
                                    style: const TextStyle(
                                      color: Color(0xFF9AA0B0),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => ref
                                .read(selectedTourismPlaceProvider.notifier)
                                .clear(),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white38,
                              size: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Category badge
                      Row(
                        children: [
                          _CategoryBadge(
                            color: color,
                            icon: icon,
                            label: label,
                          ),
                          if (place.category == 'worldHeritage') ...[
                            const SizedBox(width: 6),
                            const Tooltip(
                              message: 'UNESCO World Heritage Site',
                              child: Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFFD700),
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Description
                      if (_loadingWiki)
                        const _SkeletonLoader()
                      else if (place.wikiSummary != null &&
                          place.wikiSummary!.isNotEmpty) ...[
                        Text(
                          place.wikiSummary!,
                          style: const TextStyle(
                            color: Color(0xFFCDD0D8),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '— Wikipedia',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.22),
                            fontSize: 10,
                          ),
                        ),
                      ] else if (place.description != null)
                        Text(
                          place.description!,
                          style: const TextStyle(
                            color: Color(0xFFCDD0D8),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),

                      // Meta
                      if (place.openingHours != null) ...[
                        const SizedBox(height: 10),
                        _MetaRow(
                          icon: Icons.access_time,
                          value: place.openingHours!,
                        ),
                      ],
                      if (place.phone != null) ...[
                        const SizedBox(height: 6),
                        _MetaRow(icon: Icons.phone, value: place.phone!),
                      ],

                      const SizedBox(height: 16),

                      // Actions
                      Row(
                        children: [
                          if (place.website != null) ...[
                            Expanded(
                              child: _ActionBtn(
                                label: 'Website',
                                icon: Icons.language,
                                color: const Color(0xFF2D5A8E),
                                onTap: () => _launch(place.website!),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: _ActionBtn(
                              label: 'Directions',
                              icon: Icons.directions,
                              color: const Color(0xFF1D9E75),
                              onTap: () {
                                final mapController = ref.read(
                                  mapControllerStateProvider,
                                );
                                final currentStart = ref.read(
                                  routeStartPointProvider,
                                );
                                if (currentStart == null) {
                                  ref
                                      .read(routeStartPointProvider.notifier)
                                      .updatePoint(mapController.camera.center);
                                }
                                ref
                                    .read(routeEndPointProvider.notifier)
                                    .updatePoint(LatLng(place.lat, place.lon));
                                ref
                                    .read(isRoutingModeProvider.notifier)
                                    .updateMode(true);
                                ref
                                    .read(selectedTourismPlaceProvider.notifier)
                                    .clear();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TourismPlace place, Color color, IconData icon) {
    if (place.thumbnailUrl != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        child: Stack(
          children: [
            Image.network(
              place.thumbnailUrl!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              // FIX: named params
              errorBuilder: (context, error, stackTrace) =>
                  _gradientHeader(color, icon),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF1A1D23).withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _gradientHeader(color, icon);
  }

  Widget _gradientHeader(Color color, IconData icon) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.28),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Center(child: Icon(icon, color: color, size: 36)),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Sub-widgets ───────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _CategoryBadge({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _MetaRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Color(0xFF9AA0B0), fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader();

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.04,
      end: 0.12,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: named params in AnimatedBuilder
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final frac in [1.0, 0.88, 0.94, 0.72]) ...[
            FractionallySizedBox(
              widthFactor: frac,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _anim.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
