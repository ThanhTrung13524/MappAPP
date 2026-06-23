// lib/features/explorer/presentation/widgets/landmark_detail_sheet.dart
// FIX: curly_braces_in_flow_control_structures (if without block)
// FIX: unnecessary_underscores (__, ___) → named params

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/app_database.dart';
import '../../../../data/repositories/tourism_repository.dart';
import '../../../../shared/providers/tourism_provider.dart';

class LandmarkDetailSheet extends ConsumerStatefulWidget {
  final TourismPlace place;
  final VoidCallback onClose;

  const LandmarkDetailSheet({
    super.key,
    required this.place,
    required this.onClose,
  });

  @override
  ConsumerState<LandmarkDetailSheet> createState() =>
      _LandmarkDetailSheetState();
}

class _LandmarkDetailSheetState extends ConsumerState<LandmarkDetailSheet> {
  bool _loadingWiki = false;
  late TourismPlace _place;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
    _fetchWiki();
  }

  @override
  void didUpdateWidget(LandmarkDetailSheet old) {
    super.didUpdateWidget(old);
    if (old.place.osmId != widget.place.osmId) {
      _place = widget.place;
      _fetchWiki();
    }
  }

  Future<void> _fetchWiki() async {
    // FIX: curly_braces_in_flow_control_structures
    if (_place.wikiSummary != null) {
      return;
    }
    setState(() => _loadingWiki = true);
    final repo    = ref.read(tourismRepositoryProvider);
    final updated = await repo.ensureWikiSummary(_place);
    if (mounted) {
      setState(() {
        _place       = updated;
        _loadingWiki = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = tourismCategoryColor(_place.category);
    final icon  = tourismCategoryIcon(_place.category);
    final label = tourismCategoryLabel(_place.category);

    return Container(
      width: 340,
      color: const Color(0xFF1A1D23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroImage(color, icon),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _place.nameEn ?? _place.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            if (_place.nameEn != null &&
                                _place.nameEn != _place.name) ...[
                              const SizedBox(height: 3),
                              Text(
                                _place.name,
                                style: const TextStyle(
                                    color: Color(0xFF9AA0B0), fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white38, size: 20),
                        onPressed: widget.onClose,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Badges
                  Wrap(
                    spacing: 8,
                    children: [
                      _Badge(color: color, icon: icon, label: label),
                      if (_place.category == 'worldHeritage')
                        _Badge(
                          color: const Color(0xFFFFD700),
                          icon: Icons.emoji_events,
                          label: 'UNESCO',
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Coordinates
                  _CoordChip(lat: _place.lat, lon: _place.lon),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 16),

                  // About label
                  const Text(
                    'ABOUT',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Content
                  if (_loadingWiki)
                    _DetailSkeleton()
                  else if (_place.wikiSummary != null &&
                      _place.wikiSummary!.isNotEmpty) ...[
                    Text(
                      _place.wikiSummary!,
                      style: const TextStyle(
                          color: Color(0xFFCDD0D8), fontSize: 13, height: 1.65),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '— Wikipedia (EN)',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 10),
                    ),
                  ] else if (_place.description != null)
                    Text(
                      _place.description!,
                      style: const TextStyle(
                          color: Color(0xFFCDD0D8), fontSize: 13, height: 1.65),
                    )
                  else
                    Text(
                      'No description available.',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 13),
                    ),

                  // Meta
                  if (_place.openingHours != null ||
                      _place.phone != null ||
                      _place.website != null) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 12),
                    const Text(
                      'DETAILS',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_place.openingHours != null)
                      _DetailRow(
                          icon: Icons.access_time,
                          label: 'Hours',
                          value: _place.openingHours!),
                    if (_place.phone != null)
                      _DetailRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: _place.phone!),
                    if (_place.website != null)
                      _DetailRow(
                        icon: Icons.language,
                        label: 'Website',
                        value: _place.website!,
                        isLink: true,
                        onTap: () => _launch(_place.website!),
                      ),
                  ],

                  const SizedBox(height: 24),

                  // Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _BigActionBtn(
                        label: 'Open in Google Maps',
                        icon: Icons.near_me,
                        color: const Color(0xFF1D9E75),
                        onTap: () => _openMaps(
                            _place.lat, _place.lon,
                            _place.nameEn ?? _place.name),
                      ),
                      if (_place.website != null) ...[
                        const SizedBox(height: 8),
                        _BigActionBtn(
                          label: 'Official Website',
                          icon: Icons.language,
                          color: const Color(0xFF2D5A8E),
                          onTap: () => _launch(_place.website!),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Color color, IconData icon) {
    if (_place.thumbnailUrl != null) {
      return SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _place.thumbnailUrl!,
              fit: BoxFit.cover,
              // FIX: named params
              errorBuilder: (context, error, stackTrace) =>
                  _PlaceholderImg(color: color, icon: icon),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [const Color(0xFF1A1D23), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _PlaceholderImg(color: color, icon: icon);
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMaps(double lat, double lon, String name) =>
      _launch('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
}

// ── Sub-widgets ───────────────────────────────────────────────

class _PlaceholderImg extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _PlaceholderImg({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(child: Icon(icon, color: color, size: 52)),
    );
  }
}

class _Badge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _Badge({required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordChip extends StatelessWidget {
  final double lat, lon;
  const _CoordChip({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.white38, size: 12),
          const SizedBox(width: 5),
          Text(
            '${lat.toStringAsFixed(4)}°N, ${lon.toStringAsFixed(4)}°E',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: Colors.white38),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$label:  ',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 12),
                    ),
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        color: isLink
                            ? const Color(0xFF2D5A8E)
                            : const Color(0xFF9AA0B0),
                        fontSize: 12,
                        decoration:
                            isLink ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BigActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatefulWidget {
  @override
  State<_DetailSkeleton> createState() => _DetailSkeletonState();
}

class _DetailSkeletonState extends State<_DetailSkeleton>
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
    _anim = Tween<double>(begin: 0.04, end: 0.12).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: unnecessary_underscores → named params in AnimatedBuilder
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final frac in [1.0, 0.9, 0.95, 0.75, 0.85]) ...[
            FractionallySizedBox(
              widthFactor: frac,
              child: Container(
                height: 11,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _anim.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}