import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class ChatSyncStatusService extends BaseService {
  const ChatSyncStatusService();

  /// 获取多个会话的版本/seq信息
  Future<List<ChatSyncStatusData>> getModuleVersions(String module, List<String> conversationIds) async {
    return (db.select(db.chatSyncStatus)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.conversationId.isIn(conversationIds))).get();
  }

  /// 获取单个会话的同步状态
  Future<ChatSyncStatusData?> getSyncStatus(String module, String conversationId) async {
    return (db.select(db.chatSyncStatus)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
  }

  /// 更新同步状态
  Future<void> upsertSyncStatus({
    required String module,
    required String conversationId,
    int? seq,
    int? version,
  }) async {
    await db.into(db.chatSyncStatus).insertOnConflictUpdate(
      ChatSyncStatusCompanion(
        conversationId: Value(conversationId),
        module: Value(module),
        seq: seq != null ? Value(seq) : const Value.absent(),
        version: version != null ? Value(version) : const Value.absent(),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
    );
  }
}
