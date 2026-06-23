import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/geojson/geojson_parser.dart';
import '../../data/geojson/province_geojson_service.dart';
import 'database_provider.dart';

final geoJsonParserProvider = Provider((ref) => GeoJsonParser());

final provinceGeoJsonServiceProvider = Provider((ref) {
  return ProvinceGeoJsonService(
    unitDao: ref.watch(administrativeUnitDaoProvider),
    geoJsonDao: ref.watch(geoJsonDaoProvider),
  );
});
