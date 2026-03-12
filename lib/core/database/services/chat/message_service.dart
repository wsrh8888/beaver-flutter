import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../base.dart';

/// 聊天消息表数据访问
class MessageService extends BaseService {
  const MessageService(super.db);
  /// 插入单条消息
  Future<void> insert(ChatsCompanion row) async {
    await db.into(db.chats).insert(row);
  }

  /// 按 messageId 冲突时更新 (用于 ACK 后更新 seq、sendStatus)
  Future<void> insertOrUpdate(ChatsCompanion row) async {
    await db.into(db.chats).insert(row, mode: InsertMode.insertOrReplace);
  }

  /// 会话历史消息 (按 seq 降序，limit 条)
  Future<List<Chat>> getHistory(String conversationId, {int? beforeSeq, int limit = 20}) async {
    return await (db.select(db.chats)
          ..where((t) {
            final conv = t.conversationId.equals(conversationId);
            if (beforeSeq == null) return conv;
            return conv & t.seq.isSmallerThanValue(beforeSeq);
          })
          ..orderBy([(t) => OrderingTerm.desc(t.seq)])
          ..limit(limit))
        .get();
  }

  /// 按 messageId 查询
  Future<Chat?> getByMessageId(String messageId) async {
    return await (db.select(db.chats)..where((t) => t.messageId.equals(messageId))).getSingleOrNull();
  }

  /// 会话内「发送中」的消息 (用于 ACK 确认)
  Future<List<Chat>> getSendingByConversation(String conversationId) async {
    return await (db.select(db.chats)
          ..where((t) => t.conversationId.equals(conversationId) & t.sendStatus.equals(0)))
        .get();
  }
}
