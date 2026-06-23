import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/geojson_cache_table.dart';

part 'geojson_dao.g.dart';

@DriftAccessor(tables: [GeoJsonCaches])
class GeoJsonDao extends DatabaseAccessor<AppDatabase> with _$GeoJsonDaoMixin {
  GeoJsonDao(super.db);

  Future<void> cacheGeoJson(String ma, String data) async {
    // FIX: GeoJsonCach → GeoJsonCache (đúng tên @DataClassName trong table)
    await into(
      geoJsonCaches,
    ).insertOnConflictUpdate(GeoJsonCache(ma: ma, geoJsonData: data));
  }

  // FIX: GeoJsonCach? → GeoJsonCache?
  Future<GeoJsonCache?> getGeoJsonByMa(String ma) {
    return (select(
      geoJsonCaches,
    )..where((t) => t.ma.equals(ma))).getSingleOrNull();
  }
}
