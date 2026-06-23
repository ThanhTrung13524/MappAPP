import 'package:drift/drift.dart';

@DataClassName('School')
class Schools extends Table {
  IntColumn get osmId => integer()();
  TextColumn get name => text()();
  TextColumn get schoolType => text()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get provinceMa => text().nullable()();
  TextColumn get provinceName => text().nullable()();
  TextColumn get operator => text().nullable()();
  TextColumn get nemotronRegion => text().nullable()();

  @override
  Set<Column> get primaryKey => {osmId};
}
