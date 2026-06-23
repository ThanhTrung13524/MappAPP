// lib/core/database/tables/tourism_places_table.dart
//
// Bảng lưu cache POI du lịch từ Overpass API.
// Dùng osmId làm primary key để tránh duplicate khi re-fetch.

import 'package:drift/drift.dart';

@DataClassName('TourismPlace')
class TourismPlaces extends Table {
  /// OSM element ID — primary key
  IntColumn get osmId => integer()();

  /// Tên tiếng Việt (name tag trong OSM)
  TextColumn get name => text()();

  /// Tên tiếng Anh (name:en)
  TextColumn get nameEn => text().nullable()();

  /// Tên tiếng Trung (name:zh) — hữu ích cho khách Trung
  TextColumn get nameZh => text().nullable()();

  /// Category: 'attraction' | 'museum' | 'ruins' | 'temple' |
  ///           'viewpoint' | 'worldHeritage'
  TextColumn get category => text()();

  /// Latitude
  RealColumn get lat => real()();

  /// Longitude
  RealColumn get lon => real()();

  /// Mô tả từ OSM (description tag)
  TextColumn get description => text().nullable()();

  /// Mô tả tiếng Anh từ Wikipedia (cache sau khi fetch)
  TextColumn get wikiSummary => text().nullable()();

  /// URL ảnh thumbnail từ Wikipedia
  TextColumn get thumbnailUrl => text().nullable()();

  /// Website chính thức
  TextColumn get website => text().nullable()();

  /// Giờ mở cửa (opening_hours tag)
  TextColumn get openingHours => text().nullable()();

  /// Số điện thoại
  TextColumn get phone => text().nullable()();

  /// Wikidata QID (VD: "Q106400" cho Vịnh Hạ Long)
  TextColumn get wikidata => text().nullable()();

  /// Wikipedia page title tiếng Anh
  TextColumn get wikipedia => text().nullable()();

  /// Mã tỉnh liên kết (ma từ administrative_units)
  TextColumn get provinceMa => text().nullable()();

  /// Timestamp lần cuối fetch Wikipedia summary
  DateTimeColumn get wikiLastFetched => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {osmId};
}