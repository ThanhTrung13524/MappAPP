// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrative_unit_dao.dart';

// ignore_for_file: type=lint
mixin _$AdministrativeUnitDaoMixin on DatabaseAccessor<AppDatabase> {
  $AdministrativeUnitsTable get administrativeUnits =>
      attachedDatabase.administrativeUnits;
  AdministrativeUnitDaoManager get managers =>
      AdministrativeUnitDaoManager(this);
}

class AdministrativeUnitDaoManager {
  final _$AdministrativeUnitDaoMixin _db;
  AdministrativeUnitDaoManager(this._db);
  $$AdministrativeUnitsTableTableManager get administrativeUnits =>
      $$AdministrativeUnitsTableTableManager(
        _db.attachedDatabase,
        _db.administrativeUnits,
      );
}
