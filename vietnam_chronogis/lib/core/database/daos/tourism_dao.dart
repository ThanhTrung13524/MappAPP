// lib/core/database/daos/tourism_dao.dart

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tourism_places_table.dart';

part 'tourism_dao.g.dart';

@DriftAccessor(tables: [TourismPlaces])
class TourismDao extends DatabaseAccessor<AppDatabase> with _$TourismDaoMixin {
  TourismDao(super.db);

  // ─── Write ───────────────────────────────────────────

  Future<void> upsertPlaces(List<TourismPlace> places) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(tourismPlaces, places);
    });
  }

  Future<void> updateWikiSummary({
    required int osmId,
    required String summary,
    String? thumbnailUrl,
  }) async {
    await (update(tourismPlaces)..where((t) => t.osmId.equals(osmId))).write(
      TourismPlacesCompanion(
        wikiSummary: Value(summary),
        thumbnailUrl: Value(thumbnailUrl),
        wikiLastFetched: Value(DateTime.now()),
      ),
    );
  }

  // ─── Read ────────────────────────────────────────────

  Future<List<TourismPlace>> getAll() {
    return select(tourismPlaces).get();
  }

  Future<List<TourismPlace>> getByProvince(String provinceMa) {
    return (select(tourismPlaces)
          ..where((t) => t.provinceMa.equals(provinceMa))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<List<TourismPlace>> getByCategory(String category) {
    return (select(tourismPlaces)
          ..where((t) => t.category.equals(category)))
        .get();
  }

  Future<List<TourismPlace>> getWorldHeritage() {
    return (select(tourismPlaces)
          ..where((t) => t.category.equals('worldHeritage')))
        .get();
  }

  Future<TourismPlace?> getByOsmId(int osmId) {
    return (select(tourismPlaces)..where((t) => t.osmId.equals(osmId)))
        .getSingleOrNull();
  }

  Future<int> count() async {
    final countExp = tourismPlaces.osmId.count();
    final query = selectOnly(tourismPlaces)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<void> clearAll() => delete(tourismPlaces).go();

  // ─── Search ──────────────────────────────────────────

  Future<List<TourismPlace>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final all = await getAll();
    final q = query.toLowerCase();
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            (p.nameEn?.toLowerCase().contains(q) ?? false) ||
            (p.category.contains(q)))
        .take(20)
        .toList();
  }

  // ─── Bbox query (viewport) ───────────────────────────

  Future<List<TourismPlace>> getInBounds({
    required double minLat,
    required double maxLat,
    required double minLon,
    required double maxLon,
  }) {
    return (select(tourismPlaces)
          ..where((t) =>
              t.lat.isBetweenValues(minLat, maxLat) &
              t.lon.isBetweenValues(minLon, maxLon)))
        .get();
  }

  Future<int> deleteOutsideVietnamBBox({
    double latMin = 8.0,
    double latMax = 23.5,
    double lonMin = 102.0,
    double lonMax = 110.0,
  }) {
    return (delete(tourismPlaces)
          ..where((t) =>
              t.lat.isSmallerThanValue(latMin) |
              t.lat.isBiggerThanValue(latMax) |
              t.lon.isSmallerThanValue(lonMin) |
              t.lon.isBiggerThanValue(lonMax)))
        .go();
  }

  // ─── Delete ──────────────────────────────────────────

  Future<void> deletePlaces(List<int> osmIds) async {
    await (delete(tourismPlaces)..where((t) => t.osmId.isIn(osmIds))).go();
  }

  /// Xóa tất cả các địa điểm nằm ngoài bounding box của Việt Nam
  /// và/hoặc thuộc các category bị loại bỏ (beach, nationalPark, v.v.)
  Future<int> deleteInvalidPlaces({
    double latMin = 8.0,
    double latMax = 23.5,
    double lonMin = 102.0,
    double lonMax = 110.0,
    List<String> excludedCategories = const [
      'beach', 'nationalPark', 'national_park', 'nature',
      'natural_park', 'nature_reserve',
    ],
  }) async {
    // Xóa nằm ngoài bbox Việt Nam
    final outsideCount = await (delete(tourismPlaces)
          ..where((t) =>
              t.lat.isSmallerThanValue(latMin) |
              t.lat.isBiggerThanValue(latMax) |
              t.lon.isSmallerThanValue(lonMin) |
              t.lon.isBiggerThanValue(lonMax)))
        .go();

    // Xóa các category bị loại bỏ
    final categoryCount = await (delete(tourismPlaces)
          ..where((t) => t.category.isIn(excludedCategories)))
        .go();

    return outsideCount + categoryCount;
  }
}
