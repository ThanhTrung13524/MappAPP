// lib/shared/providers/database_provider.dart
//
// THAY THẾ file cũ — thêm tourismDaoProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/daos/tourism_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final administrativeUnitDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).administrativeUnitDao;
});

final geoJsonDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).geoJsonDao;
});

final chatDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).chatDao;
});

final tourismDaoProvider = Provider<TourismDao>((ref) {
  return ref.watch(databaseProvider).tourismDao;
});

final schoolDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).schoolDao;
});
