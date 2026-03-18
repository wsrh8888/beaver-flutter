import 'package:drift/drift.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/chat/detail/data/models/message.dart';
import 'package:beaver/features/chat/detail/data/models/types.dart';

class ChatRepository {
  final AppDatabase _database;

  ChatRepository(this._database);

  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    // 之前写的是 messages，实际是 chats
    final query = _database.select(_database.chats)
      ..where((m) => m.conversationId.equals(conversationId))
      ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
      ..limit(limit, offset: offset);
    
    final messagesList = await query.get();

    // 获取当前用户ID
    final currentUser = await _database.select(_database.users).getSingleOrNull();
    final currentUserId = currentUser?.userId ?? '';

    // 注意：drift 库生成的类名为 Chat，而不是 Message
    return messagesList
        .map((message) => MessageModel.fromChat(message, message.sendUserId == currentUserId))
        .toList()
        .reversed
        .toList();
  }

  Future<Chat> sendMessage(String conversationId, String content, MessageType type) async {
    final currentUser = await _database.select(_database.users).getSingleOrNull();
    final currentUserId = currentUser?.userId ?? '';

    // 之前写的是 MessagesCompanion，实际是 ChatsCompanion
    final companion = ChatsCompanion(
      conversationId: Value(conversationId),
      sendUserId: Value(currentUserId),
      msg: Value(content),
      msgType: Value(type.index),
      sendStatus: Value(MessageStatus.sending.index),
    );

    final id = await _database.into(_database.chats).insert(companion);
    return await (_database.select(_database.chats)..where((m) => m.id.equals(id))).getSingle();
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    await (_database.update(_database.chats)..where((m) => m.messageId.equals(messageId)))
      .write(ChatsCompanion(sendStatus: Value(status.index)));
  }

  Future<ChatConversation?> getConversation(String conversationId) async {
    // 这里应该是查询其唯一的字段 conversationId，而不是自增 ID
    return await (_database.select(_database.chatConversations)
        ..where((c) => c.conversationId.equals(conversationId)))
        .getSingleOrNull();
  }

  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return (_database.select(_database.chats)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch()
        .asyncMap((messages) async {
      final currentUser = await _database.select(_database.users).getSingleOrNull();
      final currentUserId = currentUser?.id ?? '';

      return messages
          .map((message) => MessageModel.fromChat(message, message.sendUserId == currentUserId))
          .toList();
    });
  }
}
