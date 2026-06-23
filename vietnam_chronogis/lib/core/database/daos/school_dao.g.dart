// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_dao.dart';

// ignore_for_file: type=lint
mixin _$SchoolDaoMixin on DatabaseAccessor<AppDatabase> {
  $SchoolsTable get schools => attachedDatabase.schools;
  SchoolDaoManager get managers => SchoolDaoManager(this);
}

class SchoolDaoManager {
  final _$SchoolDaoMixin _db;
  SchoolDaoManager(this._db);
  $$SchoolsTableTableManager get schools =>
      $$SchoolsTableTableManager(_db.attachedDatabase, _db.schools);
}
