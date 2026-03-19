import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

/// 会话元数据同步器
class ConversationMetaSync {
  /// 检查并同步会话元数据
  Future<void> checkAndSync() async {
    print('[ConversationMetaSync] 开始同步会话元数据');
    try {
      final datasyncService = getIt<DatasyncService>();
      final chatService = getIt<ChatConversationService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地游标
      final localCursor = await datasyncService.get('chat_conversations');
      final lastSyncTime = localCursor?.version ?? 0;

      // 获取同步摘要
      final response = await datasyncGetSyncChatConversationsApi(IGetSyncChatConversationsReq(since: lastSyncTime));
      if (response.code != 0 || response.result == null) {
        print('[ConversationMetaSync] 获取会话版本失败: ${response.msg}');
        return;
      }

      // 对比过滤
      final needUpdateConversations = await _compareAndFilterVersions(
        syncStatusService,
        response.result!.conversationVersions,
      );

      if (needUpdateConversations.isNotEmpty) {
        // 同步具体数据
        await _syncConversations(chatService, syncStatusService, needUpdateConversations);
      }

      // 更新游标
      await datasyncService.upsert(
        'chat_conversations',
        -1,
        response.result!.serverTimestamp,
      );
    } catch (error) {
      print('[ConversationMetaSync] 同步错误: $error');
    }
  }

  /// 对比版本号
  Future<List<IConversationVersionItem>> _compareAndFilterVersions(
    ChatSyncStatusService syncStatusService,
    List<IConversationVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final conversationIds = serverVersions.map((e) => e.conversationId).toList();
    final localVersions = await syncStatusService.getModuleVersions('conversation', conversationIds);
    final localVersionMap = {for (var v in localVersions) v.conversationId: v.version};

    return serverVersions.where((sv) => (localVersionMap[sv.conversationId] ?? 0) < sv.version).toList();
  }

  /// 同步会话具体内容
  Future<void> _syncConversations(
    ChatConversationService chatService,
    ChatSyncStatusService syncStatusService,
    List<IConversationVersionItem> needUpdate,
  ) async {
    final conversationIds = needUpdate.map((e) => e.conversationId).toList();
    const batchSize = 50;

    for (int i = 0; i < conversationIds.length; i += batchSize) {
      final end = (i + batchSize < conversationIds.length) ? i + batchSize : conversationIds.length;
      final batchIds = conversationIds.sublist(i, end);

      final response = await getConversationsListByIdsApi(IGetConversationsListByIdsReq(conversationIds: batchIds));
      if (response.code == 0 && response.result != null && response.result!.conversations.isNotEmpty) {
        // 映射到 Companion
        final companions = response.result!.conversations.map((c) => ChatConversationsCompanion(
          conversationId: Value(c.conversationId),
          type: Value(c.conversationType),
          title: Value(c.title ?? ''),
          avatar: Value(c.avatar ?? ''),
          version: Value(c.version),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        )).toList();

        // 更新会话数据库
        await chatService.batchCreate(companions);

        // 更新同步状态版本号
        for (final conv in response.result!.conversations) {
          await syncStatusService.upsertSyncStatus(
            module: 'conversation',
            conversationId: conv.conversationId,
            version: conv.version,
          );
        }
      }
    }
  }
}

final conversationMetaSync = ConversationMetaSync();
