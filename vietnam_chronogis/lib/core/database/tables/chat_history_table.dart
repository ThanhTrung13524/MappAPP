import 'package:drift/drift.dart';

@DataClassName('ChatHistoryMessage')
class ChatHistoryMessages extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get role => text()(); // 'user' or 'model'
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get contextJson => text().nullable()(); // Serialized context

  @override
  Set<Column> get primaryKey => {id};
}
