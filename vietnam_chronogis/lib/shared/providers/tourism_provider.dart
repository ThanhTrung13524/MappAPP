// lib/shared/providers/tourism_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/database/app_database.dart';
import '../../data/geojson/vietnam_geo_validator.dart';
import 'database_provider.dart';

// FIX: xoá tourismDaoProvider khỏi đây — đã định nghĩa trong database_provider.dart
// FIX: xoá unused imports (overpass_api_client, wikipedia_service, tourism_repository)

// ─── Toggle hiện/ẩn toàn bộ tourism layer ───────────────────

class ShowTourismLayer extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}

final showTourismLayerProvider = NotifierProvider<ShowTourismLayer, bool>(
  ShowTourismLayer.new,
);

// ─── Filter theo category ────────────────────────────────────

class TourismFilter extends Notifier<Set<String>> {
  @override
  Set<String> build() => {
    'attraction',
    'museum',
    'ruins',
    'temple',
    'viewpoint',
    'worldHeritage',
  };

  void toggleCategory(String category) {
    final current = Set<String>.from(state);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    state = current;
  }

  void selectAll() => state = {
    'attraction',
    'museum',
    'ruins',
    'temple',
    'viewpoint',
    'worldHeritage',
  };

  void clearAll() => state = {};
}

final tourismFilterProvider = NotifierProvider<TourismFilter, Set<String>>(
  TourismFilter.new,
);

// ─── Selected place ──────────────────────────────────────────

class SelectedTourismPlace extends Notifier<TourismPlace?> {
  @override
  TourismPlace? build() => null;

  void select(TourismPlace place) => state = place;
  void clear() => state = null;
  void updateWithWiki(TourismPlace updated) {
    if (state?.osmId == updated.osmId) state = updated;
  }
}

final selectedTourismPlaceProvider =
    NotifierProvider<SelectedTourismPlace, TourismPlace?>(
      SelectedTourismPlace.new,
    );

// ─── Markers provider ────────────────────────────────────────

/// List`<Marker>` cho FlutterMap MarkerLayer — re-compute khi filter thay đổi.
final tourismMarkersProvider = FutureProvider<List<Marker>>((ref) async {
  final show = ref.watch(showTourismLayerProvider);
  if (!show) return [];

  final activeCategories = ref.watch(tourismFilterProvider);
  if (activeCategories.isEmpty) {
    debugPrint('🗺️ [TourismMarkers] no active categories selected.');
    return [];
  }

  final dao = ref.watch(tourismDaoProvider);
  final validator = await VietnamGeoValidator.fromCache(
    unitDao: ref.watch(administrativeUnitDaoProvider),
    geoJsonDao: ref.watch(geoJsonDaoProvider),
  );
  final allPlaces = await dao.getAll();
  debugPrint(
    '🗺️ [TourismMarkers] loaded ${allPlaces.length} places; activeCategories=${activeCategories.length}',
  );

  var acceptedByBoundary = 0;
  var acceptedByProvinceFallback = 0;
  var rejectedByBoundary = 0;

  final filteredPlaces = allPlaces.where((p) {
    final isActiveCategory = activeCategories.contains(p.category);
    if (!isActiveCategory) return false;

    final isValid = validator.isValidVietnamPoi(lat: p.lat, lng: p.lon);
    if (isValid) {
      acceptedByBoundary++;
      return true;
    }

    final isSafeFallback =
        validator.isInsideVietnamBBox(p.lat, p.lon) && p.provinceMa != null;
    if (isSafeFallback) {
      acceptedByProvinceFallback++;
      return true;
    }

    rejectedByBoundary++;
    if (!isValid) {
      debugPrint(
        'TourismMarkers: rejected invalid POI osmId=${p.osmId}, '
        'lat=${p.lat}, lon=${p.lon}',
      );
    }
    return false;
  }).toList();
  debugPrint(
    'TourismMarkers: filtered places count=${filteredPlaces.length}; '
    'acceptedByBoundary=$acceptedByBoundary; '
    'acceptedByProvinceFallback=$acceptedByProvinceFallback; '
    'rejectedByBoundary=$rejectedByBoundary',
  );

  return filteredPlaces.map((place) {
    final color = tourismCategoryColor(place.category);
    final icon = tourismCategoryIcon(place.category);
    return Marker(
      point: LatLng(place.lat, place.lon),
      width: 36,
      height: 36,
      child: GestureDetector(
        onTap: () =>
            ref.read(selectedTourismPlaceProvider.notifier).select(place),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }).toList();
});

final tourismPlacesCountProvider = FutureProvider<int>((ref) async {
  final dao = ref.watch(tourismDaoProvider);
  return await dao.count();
});

// ─── Per-province lazy load ───────────────────────────────────

final provinceMarkersProvider =
    FutureProvider.family<List<TourismPlace>, String>((ref, provinceMa) async {
      final dao = ref.watch(tourismDaoProvider);
      return dao.getByProvince(provinceMa);
    });

// ─── Color / icon / label helpers ────────────────────────────

Color tourismCategoryColor(String category) {
  switch (category) {
    case 'museum':
      return const Color(0xFF9C27B0);
    case 'ruins':
      return const Color(0xFFFFC107);
    case 'temple':
      return const Color(0xFFFF7043);
    case 'viewpoint':
      return const Color(0xFF03A9F4);
    case 'worldHeritage':
      return const Color(0xFFE91E63);
    default:
      return const Color(0xFFFF9800);
  }
}

IconData tourismCategoryIcon(String category) {
  switch (category) {
    case 'museum':
      return Icons.museum;
    case 'ruins':
      return Icons.account_balance;
    case 'temple':
      return Icons.temple_buddhist;
    case 'viewpoint':
      return Icons.photo_camera;
    case 'worldHeritage':
      return Icons.emoji_events;
    default:
      return Icons.place;
  }
}

String tourismCategoryLabel(String category) {
  switch (category) {
    case 'museum':
      return 'Museum';
    case 'ruins':
      return 'Historic Ruins';
    case 'temple':
      return 'Temple / Pagoda';
    case 'viewpoint':
      return 'Viewpoint';
    case 'worldHeritage':
      return 'UNESCO Heritage';
    default:
      return 'Attraction';
  }
}
