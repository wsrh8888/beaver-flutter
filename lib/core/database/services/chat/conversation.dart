import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class ChatConversationService extends BaseService {
  const ChatConversationService();

  /// 创建单个会话
  Future<void> create(ChatConversationsCompanion conversation) async {
    await db.into(db.chatConversations).insert(conversation);
  }

  /// upsert单个会话（插入或更新）
  Future<void> upsert(ChatConversationsCompanion conversation) async {
    final conversationId = conversation.conversationId.value;
    final existing = await (db.select(db.chatConversations)
          ..where((t) => t.conversationId.equals(conversationId))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.chatConversations)
            ..where((t) => t.conversationId.equals(conversationId)))
          .write(conversation);
    } else {
      await db.into(db.chatConversations).insert(conversation);
    }
  }

  /// 批量创建会话（支持插入或更新）
  Future<void> batchCreate(List<ChatConversationsCompanion> conversations) async {
    if (conversations.isEmpty) return;
    for (final conversation in conversations) {
      await upsert(conversation);
    }
  }

  /// 获取所有会话（本地数据库场景，支持分页）
  Future<List<ChatConversation>> getAllConversations({int? page, int? limit}) async {
    var query = db.select(db.chatConversations);

    if (limit != null && page != null) {
      final offset = (page - 1) * limit;
      query = query..limit(limit, offset: offset);
    }

    return query.get();
  }

  /// 根据会话ID列表批量获取会话元数据（包含最后消息）
  Future<List<ChatConversation>> getConversationsByIds(List<String> conversationIds) async {
    if (conversationIds.isEmpty) {
      return [];
    }
    return (db.select(db.chatConversations)..where((t) => t.conversationId.isIn(conversationIds))).get();
  }

  /// 根据会话ID获取单个会话元数据
  Future<ChatConversation?> getConversationById(String conversationId) async {
    return (db.select(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
  }

  /// 根据类型获取会话（纯数据库查询）
  Future<List<ChatConversation>> getConversationsByType(int type) async {
    return (db.select(db.chatConversations)..where((t) => t.type.equals(type))).get();
  }

  /// 更新会话的最后消息
  Future<void> updateLastMessage(String conversationId, String lastMessage, {int? maxSeq}) async {
    await (db.update(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).write(
      ChatConversationsCompanion(
        lastMessage: Value(lastMessage),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        maxSeq: maxSeq != null ? Value(maxSeq) : const Value.absent(),
      ),
    );
  }

  /// 获取会话列表（按更新时间降序）
  Future<List<ChatConversation>> getConversations() async {
    return (db.select(db.chatConversations)..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])).get();
  }

  /// 删除会话
  Future<void> deleteConversation(String conversationId) async {
    await (db.delete(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).go();
  }
}
