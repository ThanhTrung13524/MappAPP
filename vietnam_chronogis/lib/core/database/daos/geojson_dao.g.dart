// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson_dao.dart';

// ignore_for_file: type=lint
mixin _$GeoJsonDaoMixin on DatabaseAccessor<AppDatabase> {
  $GeoJsonCachesTable get geoJsonCaches => attachedDatabase.geoJsonCaches;
  GeoJsonDaoManager get managers => GeoJsonDaoManager(this);
}

class GeoJsonDaoManager {
  final _$GeoJsonDaoMixin _db;
  GeoJsonDaoManager(this._db);
  $$GeoJsonCachesTableTableManager get geoJsonCaches =>
      $$GeoJsonCachesTableTableManager(_db.attachedDatabase, _db.geoJsonCaches);
}
