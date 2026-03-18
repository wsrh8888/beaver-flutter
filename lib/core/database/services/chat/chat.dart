import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/chat.dart';

class ChatService extends BaseService {
  ChatService(super.db);

  /// 批量更新会话信息
  Future<void> upsertConversations(List<IConversationItem> conversations) async {
    await db.batch((batch) {
      for (final conv in conversations) {
        batch.insert(
          db.chatConversations,
          ChatConversationsCompanion(
            conversationId: Value(conv.conversationId),
            type: Value(conv.conversationType),
            title: Value(conv.title),
            avatar: Value(conv.avatar),
            version: Value(conv.version),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 批量同步用户会话设置
  Future<void> batchCreateUserConversations(List<IUserConversationSettingItem> settings) async {
    await db.batch((batch) {
      for (final uc in settings) {
        batch.insert(
          db.chatUserConversations,
          ChatUserConversationsCompanion(
            userId: Value(uc.userId),
            conversationId: Value(uc.conversationId),
            isHidden: Value(uc.isHidden ? 1 : 0),
            isPinned: Value(uc.isPinned ? 1 : 0),
            isMuted: Value(uc.isMuted ? 1 : 0),
            userReadSeq: Value(uc.userReadSeq),
            version: Value(uc.version),
            createdAt: Value(uc.createdAt),
            updatedAt: Value(uc.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 批量创建消息
  Future<void> batchCreateMessages(List<IChatMessageItem> messages) async {
    await db.batch((batch) {
      for (final msg in messages) {
        batch.insert(
          db.chats,
          ChatsCompanion(
            messageId: Value(msg.messageId),
            conversationId: Value(msg.conversationId),
            conversationType: Value(msg.conversationType),
            sendUserId: Value(msg.sendUserId),
            msgType: Value(msg.msgType),
            targetMessageId: Value(msg.targetMessageId),
            msgPreview: Value(msg.msgPreview),
            msg: Value(msg.msg),
            seq: Value(msg.seq),
            createdAt: Value(msg.createdAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}