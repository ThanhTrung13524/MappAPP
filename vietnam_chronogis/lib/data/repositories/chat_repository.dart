import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/daos/chat_dao.dart';
import '../../shared/models/chat_message.dart';
// FIX: dùng databaseProvider thay vì appDatabaseProvider (không tồn tại)
import '../../shared/providers/database_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(databaseProvider); // FIX: was appDatabaseProvider
  return ChatRepository(db.chatDao);
});

class ChatRepository {
  final ChatDao _chatDao;

  ChatRepository(this._chatDao);

  Future<void> saveMessage(ChatMessage message) async {
    await _chatDao.insertMessage(
      ChatHistoryMessage(
        id: message.id,
        role: message.role.name,
        content: message.content,
        timestamp: message.timestamp,
        contextJson: null,
      ),
    );
  }

  Stream<List<ChatMessage>> watchMessages() {
    return _chatDao.watchAllMessages().map((rows) {
      return rows.map((row) {
        return ChatMessage(
          id: row.id,
          role: MessageRole.values.firstWhere(
            (e) => e.name == row.role,
            orElse: () => MessageRole.user,
          ),
          content: row.content,
          timestamp: row.timestamp,
          isStreaming: false,
        );
      }).toList();
    });
  }

  Future<void> clearHistory() async {
    await _chatDao.clearHistory();
  }
}