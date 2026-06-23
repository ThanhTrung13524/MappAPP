import 'package:drift/drift.dart';

@DataClassName('HistoricalEvent')
class HistoricalEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get startYear => integer()();
  IntColumn get endYear => integer().nullable()();
  TextColumn get eventType => text()(); // e.g. 'MERGER', 'SPLIT', 'POLICY'
  TextColumn get relatedProvinceMas => text()(); // Comma-separated list of affected province `ma`s
}
