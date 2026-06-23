// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dao.dart';

// ignore_for_file: type=lint
mixin _$ChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatHistoryMessagesTable get chatHistoryMessages =>
      attachedDatabase.chatHistoryMessages;
  ChatDaoManager get managers => ChatDaoManager(this);
}

class ChatDaoManager {
  final _$ChatDaoMixin _db;
  ChatDaoManager(this._db);
  $$ChatHistoryMessagesTableTableManager get chatHistoryMessages =>
      $$ChatHistoryMessagesTableTableManager(
        _db.attachedDatabase,
        _db.chatHistoryMessages,
      );
}
