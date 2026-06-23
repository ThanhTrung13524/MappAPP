import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/administrative_units_table.dart';

part 'administrative_unit_dao.g.dart';

@DriftAccessor(tables: [AdministrativeUnits])
class AdministrativeUnitDao extends DatabaseAccessor<AppDatabase> with _$AdministrativeUnitDaoMixin {
  AdministrativeUnitDao(super.db);

  Future<void> upsertUnit(AdministrativeUnit unit) async {
    await into(administrativeUnits).insertOnConflictUpdate(unit);
  }

  Future<void> insertMultiple(List<AdministrativeUnit> units) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(administrativeUnits, units);
    });
  }

  Future<List<AdministrativeUnit>> getAllProvinces() {
    return (select(administrativeUnits)
          ..where(
            (t) =>
                t.kind.equals('province') |
                t.type.isIn(['Tỉnh', 'Thành phố', 'Tinh', 'Thanh pho']),
          ))
        .get();
  }

  Future<List<AdministrativeUnit>> getCommunesByProvince(String parentMa) {
    return (select(administrativeUnits)
          ..where((t) => t.kind.equals('commune') & t.parentMa.equals(parentMa))
          ..orderBy([(t) => OrderingTerm(expression: t.ten, mode: OrderingMode.asc)]))
        .get();
  }

  Future<AdministrativeUnit?> getUnitByMa(String ma) async {
    final list = await (select(administrativeUnits)
          ..where((t) => t.ma.equals(ma))
          ..limit(1))
        .get();
    return list.isNotEmpty ? list.first : null;
  }

  Future<List<AdministrativeUnit>> getProvincesByRegion(String region) {
    return (select(administrativeUnits)
          ..where(
            (t) =>
                (t.kind.equals('province') |
                    t.type.isIn(['Tỉnh', 'Thành phố', 'Tinh', 'Thanh pho'])) &
                t.macroRegion.equals(region),
          ))
        .get();
  }

  Future<List<AdministrativeUnit>> searchUnits(String query) async {
    if (query.trim().isEmpty) return [];
    
    final allUnits = await (select(administrativeUnits)
          ..where(
            (t) =>
                t.kind.isIn(['province', 'commune']) |
                t.type.isIn(['Tỉnh', 'Thành phố', 'Tinh', 'Thanh pho']),
          ))
        .get();

    final normalizedQuery = _normalizeVietnamese(query);

    return allUnits.where((unit) {
      final normalizedTen = _normalizeVietnamese(unit.ten);
      final normalizedTenShort = _normalizeVietnamese(unit.tenShort);
      return normalizedTen.contains(normalizedQuery) ||
          normalizedTenShort.contains(normalizedQuery);
    }).take(10).toList();
  }

  String _normalizeVietnamese(String input) {
    var str = input.toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    // Remove extra spaces and punctuation
    str = str.replaceAll(RegExp(r'[^a-z0-9 ]'), '');
    return str.trim();
  }
}
