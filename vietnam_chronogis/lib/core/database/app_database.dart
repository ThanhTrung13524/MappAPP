// lib/core/database/app_database.dart
//
// THAY THẾ file cũ — thêm TourismPlaces table + TourismDao.
// Tăng schemaVersion lên 2, thêm migration onCreate tạo table mới.

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'tables/administrative_units_table.dart';
import 'tables/historical_events_table.dart';
import 'tables/geojson_cache_table.dart';
import 'tables/chat_history_table.dart';
import 'tables/tourism_places_table.dart';
import 'tables/schools_table.dart';
import 'daos/administrative_unit_dao.dart';
import 'daos/geojson_dao.dart';
import 'daos/chat_dao.dart';
import 'daos/tourism_dao.dart';
import 'daos/school_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AdministrativeUnits,
    HistoricalEvents,
    GeoJsonCaches,
    ChatHistoryMessages,
    TourismPlaces,
    Schools,
  ],
  daos: [
    AdministrativeUnitDao,
    GeoJsonDao,
    ChatDao,
    TourismDao,
    SchoolDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 → v2: tạo bảng tourism_places
        if (from < 2) {
          await m.createTable(tourismPlaces);
        }
        if (from < 3) {
          await m.createTable(schools);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'vietnam_chronogis', 'chronogis.sqlite'),
    );

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
