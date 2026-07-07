import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/schools_table.dart';

part 'school_dao.g.dart';

@DriftAccessor(tables: [Schools])
class SchoolDao extends DatabaseAccessor<AppDatabase> with _$SchoolDaoMixin {
  SchoolDao(super.db);

  Future<void> upsertSchools(List<School> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(schools, items);
    });
  }

  Future<List<School>> getAll() {
    return (select(
      schools,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
  }

  Future<List<School>> getByProvince(String provinceMa) {
    return (select(schools)
          ..where((t) => t.provinceMa.equals(provinceMa))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<List<School>> getByType(String schoolType) {
    return (select(
      schools,
    )..where((t) => t.schoolType.equals(schoolType))).get();
  }

  Future<List<School>> getInBounds({
    double minLat = 8.0,
    double maxLat = 23.5,
    double minLon = 102.0,
    double maxLon = 110.0,
  }) {
    return (select(schools)
          ..where(
            (t) =>
                t.lat.isBetweenValues(minLat, maxLat) &
                t.lon.isBetweenValues(minLon, maxLon),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<School?> getByOsmId(int osmId) {
    return (select(
      schools,
    )..where((t) => t.osmId.equals(osmId))).getSingleOrNull();
  }

  Future<int> count() async {
    final countExp = schools.osmId.count();
    final query = selectOnly(schools)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<School>> search(String queryText) async {
    final trimmedQuery = queryText.trim();
    if (trimmedQuery.isEmpty) return [];

    final likeQuery = '%$trimmedQuery%';
    return (select(schools)
          ..where(
            (t) =>
                t.name.like(likeQuery) |
                t.address.like(likeQuery) |
                t.provinceName.like(likeQuery),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.name)])
          ..limit(50))
        .get();
  }

  Future<void> clearAll() => delete(schools).go();
}
