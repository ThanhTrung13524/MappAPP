// lib/features/explorer/presentation/widgets/landmark_card.dart
// FIX: unnecessary_underscores → dùng named params trong errorBuilder & builder

import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/tourism_provider.dart';

class LandmarkCard extends StatefulWidget {
  final TourismPlace place;
  final VoidCallback onTap;

  const LandmarkCard({super.key, required this.place, required this.onTap});

  @override
  State<LandmarkCard> createState() => _LandmarkCardState();
}

class _LandmarkCardState extends State<LandmarkCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final color = tourismCategoryColor(place.category);
    final icon  = tourismCategoryIcon(place.category);
    final label = tourismCategoryLabel(place.category);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF252830) : const Color(0xFF1E2128),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? color.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.05),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image / gradient header ─────────────
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(11)),
                  child: place.thumbnailUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              place.thumbnailUrl!,
                              fit: BoxFit.cover,
                              // FIX: dùng named params thay vì __, ___
                              errorBuilder: (context, error, stackTrace) =>
                                  _PlaceholderHeader(color: color, icon: icon),
                            ),
                            // Bottom gradient
                            Positioned(
                              bottom: 0, left: 0, right: 0,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (place.category == 'worldHeritage')
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.emoji_events,
                                          color: Color(0xFFFFD700), size: 10),
                                      SizedBox(width: 3),
                                      Text(
                                        'UNESCO',
                                        style: TextStyle(
                                          color: Color(0xFFFFD700),
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      : _PlaceholderHeader(color: color, icon: icon),
                ),
              ),

              // ── Info area ───────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: color, size: 11),
                          const SizedBox(width: 4),
                          Text(
                            label.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        place.nameEn ?? place.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (place.nameEn != null &&
                          place.nameEn != place.name) ...[
                        const SizedBox(height: 2),
                        Text(
                          place.name,
                          style: const TextStyle(
                              color: Color(0xFF9AA0B0), fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      if (place.wikiSummary != null &&
                          place.wikiSummary!.isNotEmpty)
                        Text(
                          place.wikiSummary!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
}

class _PlaceholderHeader extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _PlaceholderHeader({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, color: color.withValues(alpha: 0.6), size: 40),
      ),
    );
  }
}