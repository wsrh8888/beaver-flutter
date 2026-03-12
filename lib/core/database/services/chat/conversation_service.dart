import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../base.dart';

/// 会话表数据访问
class ConversationService extends BaseService {
  const ConversationService(super.db);
  /// 插入或替换会话元数据
  Future<void> upsert(ChatConversationsCompanion row) async {
    await db.into(db.chatConversations).insert(row, mode: InsertMode.insertOrReplace);
  }

  /// 按 conversationId 查询
  Future<ChatConversation?> getByConversationId(String conversationId) async {
    return await (db.select(db.chatConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .getSingleOrNull();
  }

  /// 查询所有会话
  Future<List<ChatConversation>> getAll() async {
    return await db.select(db.chatConversations).get();
  }
}
