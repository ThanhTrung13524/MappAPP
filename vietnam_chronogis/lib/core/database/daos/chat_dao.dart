import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/chat_history_table.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [ChatHistoryMessages])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  Future<void> insertMessage(ChatHistoryMessage message) async {
    await into(chatHistoryMessages).insert(message);
  }

  Future<List<ChatHistoryMessage>> getRecentMessages({int limit = 50}) {
    return (select(chatHistoryMessages)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }

  Stream<List<ChatHistoryMessage>> watchAllMessages() {
    return (select(chatHistoryMessages)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<void> clearHistory() async {
    await delete(chatHistoryMessages).go();
  }
}
