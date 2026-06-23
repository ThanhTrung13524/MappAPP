import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/database/app_database.dart';
import '../../data/api/nemotron_api_client.dart';
import '../../data/api/models/nemotron_row_model.dart';
import '../../data/geojson/vietnam_geo_validator.dart';
import 'database_provider.dart';

class ShowSchoolsLayer extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}

final showSchoolsLayerProvider = NotifierProvider<ShowSchoolsLayer, bool>(
  ShowSchoolsLayer.new,
);

class SelectedSchool extends Notifier<School?> {
  @override
  School? build() => null;
  void select(School school) => state = school;
  void clear() => state = null;
}

final selectedSchoolProvider = NotifierProvider<SelectedSchool, School?>(
  SelectedSchool.new,
);

class SchoolsSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final schoolsSearchProvider = NotifierProvider<SchoolsSearch, String>(
  SchoolsSearch.new,
);

final schoolMarkersProvider = FutureProvider<List<Marker>>((ref) async {
  final show = ref.watch(showSchoolsLayerProvider);
  if (!show) return [];

  final dao = ref.watch(schoolDaoProvider);
  final validator = await VietnamGeoValidator.fromCache(
    unitDao: ref.watch(administrativeUnitDaoProvider),
    geoJsonDao: ref.watch(geoJsonDaoProvider),
  );
  final schools = await dao.getAll();

  return schools.where((s) => validator.isInsideVietnamBBox(s.lat, s.lon)).map(
    (school) {
      return Marker(
        point: LatLng(school.lat, school.lon),
        width: 34,
        height: 34,
        child: GestureDetector(
          onTap: () => ref.read(selectedSchoolProvider.notifier).select(school),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
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
            child: const Icon(Icons.school, color: Colors.white, size: 18),
          ),
        ),
      );
    },
  ).toList();
});

final schoolsListProvider = FutureProvider<List<School>>((ref) async {
  final dao = ref.watch(schoolDaoProvider);
  final search = ref.watch(schoolsSearchProvider);
  if (search.trim().isNotEmpty) {
    return dao.search(search.trim());
  }
  return dao.getAll();
});

final nemotronApiClientProvider = Provider<NemotronApiClient>((ref) {
  return NemotronApiClient();
});

final schoolEducationStatsProvider =
    FutureProvider.family<EducationStats?, String?>((ref, region) async {
  if (region == null || region.isEmpty) return null;
  final client = ref.watch(nemotronApiClientProvider);
  return client.fetchEducationStatsForRegion(region);
});

String schoolTypeLabel(String type) {
  switch (type) {
    case 'specialized':
      return 'THPT Chuyên';
    case 'international':
      return 'Quốc tế';
    case 'thpt':
      return 'THPT';
    default:
      return 'Trung học phổ thông';
  }
}
