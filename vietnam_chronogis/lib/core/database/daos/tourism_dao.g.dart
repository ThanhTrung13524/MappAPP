// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tourism_dao.dart';

// ignore_for_file: type=lint
mixin _$TourismDaoMixin on DatabaseAccessor<AppDatabase> {
  $TourismPlacesTable get tourismPlaces => attachedDatabase.tourismPlaces;
  TourismDaoManager get managers => TourismDaoManager(this);
}

class TourismDaoManager {
  final _$TourismDaoMixin _db;
  TourismDaoManager(this._db);
  $$TourismPlacesTableTableManager get tourismPlaces =>
      $$TourismPlacesTableTableManager(_db.attachedDatabase, _db.tourismPlaces);
}
