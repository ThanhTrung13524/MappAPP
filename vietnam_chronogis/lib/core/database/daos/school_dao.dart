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
    return (select(schools)..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<List<School>> getByProvince(String provinceMa) {
    return (select(schools)
          ..where((t) => t.provinceMa.equals(provinceMa))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<List<School>> getByType(String schoolType) {
    return (select(schools)..where((t) => t.schoolType.equals(schoolType))).get();
  }

  Future<School?> getByOsmId(int osmId) {
    return (select(schools)..where((t) => t.osmId.equals(osmId))).getSingleOrNull();
  }

  Future<int> count() async {
    final countExp = schools.osmId.count();
    final query = selectOnly(schools)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<School>> search(String queryText) async {
    if (queryText.trim().isEmpty) return [];
    final q = queryText.toLowerCase();
    final all = await getAll();
    return all
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              (s.address?.toLowerCase().contains(q) ?? false) ||
              (s.provinceName?.toLowerCase().contains(q) ?? false),
        )
        .take(50)
        .toList();
  }

  Future<void> clearAll() => delete(schools).go();
}
