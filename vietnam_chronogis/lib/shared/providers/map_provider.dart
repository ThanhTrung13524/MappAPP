import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import 'database_provider.dart';

part 'map_provider.g.dart';

@riverpod
class SelectedProvince extends _$SelectedProvince {
  @override
  String? build() {
    return null;
  }

  void select(String ma) {
    state = ma;
  }

  void clear() {
    state = null;
  }
}

enum MapTileStyle { street, satellite }

@riverpod
class MapTileStyleState extends _$MapTileStyleState {
  @override
  MapTileStyle build() {
    return MapTileStyle.street;
  }

  void toggle() {
    state = state == MapTileStyle.street
        ? MapTileStyle.satellite
        : MapTileStyle.street;
  }
}

@riverpod
class ShowBordersState extends _$ShowBordersState {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}

@riverpod
class ShowHeatmapState extends _$ShowHeatmapState {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    debugPrint('⚙️ [ShowHeatmapState.toggle] $state → ${!state}');
    state = !state;
  }
}

@riverpod
class MapControllerState extends _$MapControllerState {
  @override
  MapController build() {
    return MapController();
  }
}

class MapSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String value) {
    state = value;
  }
}

final mapSearchQueryProvider = NotifierProvider<MapSearchQuery, String>(
  MapSearchQuery.new,
);

final mapSearchResultsProvider = FutureProvider<List<AdministrativeUnit>>((
  ref,
) async {
  final query = ref.watch(mapSearchQueryProvider);
  if (query.trim().isEmpty) return [];
  final dao = ref.watch(administrativeUnitDaoProvider);
  return dao.searchUnits(query);
});

class SavedLocations extends AsyncNotifier<List<String>> {
  late SharedPreferences _prefs;

  @override
  Future<List<String>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getStringList('saved_locations_ma') ?? [];
  }

  Future<void> toggleSave(String ma) async {
    final current = state.value ?? [];
    final List<String> updated = List.from(current);
    if (updated.contains(ma)) {
      updated.remove(ma);
    } else {
      updated.add(ma);
    }
    state = AsyncValue.data(updated);
    await _prefs.setStringList('saved_locations_ma', updated);
  }
}

final savedLocationsProvider =
    AsyncNotifierProvider<SavedLocations, List<String>>(SavedLocations.new);

final savedAdministrativeUnitsProvider =
    FutureProvider<List<AdministrativeUnit>>((ref) async {
      final savedCodesAsync = ref.watch(savedLocationsProvider);
      final savedCodes = savedCodesAsync.value ?? [];
      if (savedCodes.isEmpty) return [];

      final dao = ref.watch(administrativeUnitDaoProvider);
      final List<AdministrativeUnit> units = [];
      for (final code in savedCodes) {
        final unit = await dao.getUnitByMa(code);
        if (unit != null) {
          units.add(unit);
        }
      }
      return units;
    });
