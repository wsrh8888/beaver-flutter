import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/chat/detail/data/models/message.dart';

class ChatRepository {
  final AppDatabase _database;

  ChatRepository(this._database);

  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    final messages = await (_database.select(_database.messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy((m) => OrderingTerm.desc(m.createdAt))
          ..limit(limit, offset: offset))
        .get();

    // 获取当前用户ID
    final currentUser = await _database.select(_database.users).getSingleOrNull();
    final currentUserId = currentUser?.id ?? '';

    return messages
        .map((message) => MessageModel.fromMessage(message, message.senderId == currentUserId))
        .toList()
        .reversed
        .toList();
  }

  Future<Message> sendMessage(String conversationId, String content, MessageType type) async {
    // 获取当前用户ID
    final currentUser = await _database.select(_database.users).getSingleOrNull();
    final currentUserId = currentUser?.id ?? '';

    final message = MessagesCompanion(
      conversationId: Value(conversationId),
      senderId: Value(currentUserId),
      content: Value(content),
      type: Value(type),
      status: Value(MessageStatus.sending),
      createdAt: Value(DateTime.now()),
    );

    final id = await _database.into(_database.messages).insert(message);
    return (await _database.select(_database.messages).where((m) => m.id.equals(id)).getSingle());
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    await _database.update(_database.messages)
      ..where((m) => m.id.equals(messageId))
      ..write(MessagesCompanion(status: Value(status)));
  }

  Future<Conversation?> getConversation(String conversationId) async {
    return await _database.select(_database.chatConversations)
        .where((c) => c.id.equals(conversationId))
        .getSingleOrNull();
  }

  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return (_database.select(_database.messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy((m) => OrderingTerm.asc(m.createdAt)))
        .watch()
        .asyncMap((messages) async {
      final currentUser = await _database.select(_database.users).getSingleOrNull();
      final currentUserId = currentUser?.id ?? '';

      return messages
          .map((message) => MessageModel.fromMessage(message, message.senderId == currentUserId))
          .toList();
    });
  }
}

