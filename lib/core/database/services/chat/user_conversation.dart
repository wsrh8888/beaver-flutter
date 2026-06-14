import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class ChatUserConversationService extends BaseService {
  const ChatUserConversationService();

  /// 创建单个用户会话设置
  Future<void> create(ChatUserConversationsCompanion setting) async {
    await db.into(db.chatUserConversations).insert(setting);
  }

  /// upsert单个用户会话设置（插入或更新）
  Future<void> upsert(ChatUserConversationsCompanion setting) async {
    final conversationId = setting.conversationId.value;
    final existing = await (db.select(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.chatUserConversations)
            ..where((t) => t.conversationId.equals(conversationId)))
          .write(setting);
    } else {
      await db.into(db.chatUserConversations).insert(setting);
    }
  }

  /// 批量创建用户会话设置（支持插入或更新）
  Future<void> batchCreate(List<ChatUserConversationsCompanion> settings) async {
    if (settings.isEmpty) return;

    for (final setting in settings) {
      await upsert(setting);
    }
  }

  /// 根据会话ID获取用户会话设置
  Future<ChatUserConversation?> getByConversationId(String conversationId) async {
    return (db.select(db.chatUserConversations)..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
  }

  /// 根据用户ID获取所有用户会话设置
  Future<List<ChatUserConversation>> getByUserId(String userId) async {
    return (db.select(db.chatUserConversations)..where((t) => t.userId.equals(userId))).get();
  }

  /// 置顶/取消置顶会话
  Future<void> togglePinConversation(String conversationId, bool isPinned) async {
    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          isPinned: Value(isPinned ? 1 : 0),
        ));
  }

  /// 免打扰/取消免打扰
  Future<void> toggleMuteConversation(String conversationId, bool isMuted) async {
    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          isMuted: Value(isMuted ? 1 : 0),
        ));
  }

  /// 标记已读
  Future<void> markAsRead(String conversationId, int userReadSeq) async {
    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          userReadSeq: Value(userReadSeq),
        ));
  }

  /// 删除用户会话设置
  Future<void> delete(String conversationId) async {
    await (db.delete(db.chatUserConversations)..where((t) => t.conversationId.equals(conversationId))).go();
  }

  /// 批量删除用户会话设置
  Future<void> batchDelete(List<String> conversationIds) async {
    if (conversationIds.isEmpty) {
      return;
    }
    await (db.delete(db.chatUserConversations)..where((t) => t.conversationId.isIn(conversationIds))).go();
  }
}
