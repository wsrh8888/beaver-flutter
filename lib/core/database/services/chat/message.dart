import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class ChatMessageService extends BaseService {
  ChatMessageService(super.db);

  /// upsert单条消息
  Future<void> upsert(ChatsCompanion message) async {
    final messageId = message.messageId.value;
    final existing = await (db.select(db.chats)
          ..where((t) => t.messageId.equals(messageId))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.chats)..where((t) => t.messageId.equals(messageId))).write(message);
    } else {
      await db.into(db.chats).insert(message);
    }
  }

  /// 创建单条消息
  Future<void> create(ChatsCompanion message) async {
    await upsert(message);
  }

  /// 批量创建消息（一次性插入所有消息，如果重复则更新关键字段）
  Future<void> batchCreate(List<ChatsCompanion> messages) async {
    if (messages.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final message in messages) {
        batch.insert(
          db.chats,
          message,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 批量更新消息的发送状态（用于收到服务器消息后，更新本地已发送消息的状态）
  Future<void> batchUpdateSendStatus(List<String> messageIds, int sendStatus, {Map<String, int>? seqMap}) async {
    if (messageIds.isEmpty) {
      return;
    }

    if (seqMap != null && seqMap.isNotEmpty) {
      for (final messageId in messageIds) {
        final seq = seqMap[messageId];
        await (db.update(db.chats)..where((t) => t.messageId.equals(messageId))).write(
          ChatsCompanion(
            sendStatus: Value(sendStatus),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            seq: seq != null ? Value(seq) : const Value.absent(),
          ),
        );
      }
    } else {
      await (db.update(db.chats)..where((t) => t.messageId.isIn(messageIds))).write(
        ChatsCompanion(
          sendStatus: Value(sendStatus),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        ),
      );
    }
  }

  /// 获取会话的历史消息（纯数据库查询，不含业务逻辑）
  Future<List<Chat>> getChatHistory(
    String conversationId, {
    int? seq,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = db.select(db.chats)
      ..where((t) => t.conversationId.equals(conversationId));

    if (seq != null) {
      query = query ..where((t) => t.seq.isSmallerThanValue(seq));
    }

    return (query
          ..orderBy([
            (t) => OrderingTerm(expression: t.seq, mode: OrderingMode.desc),
          ])
          ..limit(limit + 1, offset: offset))
        .get();
  }

  /// 按序列号范围获取消息（纯数据库查询，不含业务逻辑）
  Future<List<Chat>> getChatMessagesBySeqRange(String conversationId, int startSeq, int endSeq) async {
    return (db.select(db.chats)
          ..where((t) =>
              t.conversationId.equals(conversationId) &
              t.seq.isBiggerOrEqualValue(startSeq) &
              t.seq.isSmallerOrEqualValue(endSeq))
          ..orderBy([(t) => OrderingTerm(expression: t.seq)]))
        .get();
  }

  /// 批量删除消息（物理删除）
  Future<void> batchDelete(List<String> messageIds) async {
    if (messageIds.isEmpty) {
      return;
    }
    await (db.delete(db.chats)..where((t) => t.messageId.isIn(messageIds))).go();
  }

  /// 获取单条消息
  Future<Chat?> getById(String messageId) async {
    return (db.select(db.chats)..where((t) => t.messageId.equals(messageId))).getSingleOrNull();
  }

  /// 获取某个会话中所有"发送中"的消息（用于 ACK 确认）
  Future<List<Chat>> getSendingMessages(String conversationId) async {
    return (db.select(db.chats)
          ..where((t) => t.conversationId.equals(conversationId) & t.sendStatus.equals(0)))
        .get();
  }

  /// 清空会话的所有消息
  Future<void> clearHistory(String conversationId) async {
    await (db.delete(db.chats)..where((t) => t.conversationId.equals(conversationId))).go();
  }
}
