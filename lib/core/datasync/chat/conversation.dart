import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';

/// 会话元数据同步
class ConversationMetaSync {
  Future<void> checkAndSync() async {
    print('[ConversationMetaSync] 开始同步会话元数据');

    final datasyncService = getIt<DatasyncService>();
    final chatService = getIt<ChatService>();
    final syncStatusService = getIt<ChatSyncStatusService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('chat_conversations');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncChatConversationsApi(IGetSyncChatConversationsReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) {
      print('[ConversationMetaSync] 获取会话版本失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比过滤
    final needUpdate = await _compareAndFilterVersions(syncStatusService, response.result!.conversationVersions);

    if (needUpdate.isNotEmpty) {
      // 4. 同步具体数据
      await _syncConversations(chatService, syncStatusService, needUpdate);
    }

    // 5. 更新游标
    await datasyncService.upsert('chat_conversations', -1, serverTimestamp);
    
    print('[ConversationMetaSync] 会话元数据同步完成');
  }

  Future<List<IConversationVersionItem>> _compareAndFilterVersions(
    ChatSyncStatusService syncStatusService,
    List<IConversationVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final conversationIds = serverVersions.map((e) => e.conversationId).toList();
    final localVersions = await syncStatusService.getModuleVersions('conversation', conversationIds);
    final localMap = {for (var v in localVersions) v.conversationId: v.version};

    return serverVersions.where((sv) => (localMap[sv.conversationId] ?? 0) < sv.version).toList();
  }

  Future<void> _syncConversations(
    ChatService chatService,
    ChatSyncStatusService syncStatusService,
    List<IConversationVersionItem> needUpdate,
  ) async {
    final conversationIds = needUpdate.map((e) => e.conversationId).toList();
    const batchSize = 50;
    for (int i = 0; i < conversationIds.length; i += batchSize) {
      final batchIds = conversationIds.sublist(i, i + batchSize > conversationIds.length ? conversationIds.length : i + batchSize);
      final response = await getConversationsListByIdsApi(IGetConversationsListByIdsReq(conversationIds: batchIds));
      if (response.code == 0 && response.result != null) {
        await chatService.upsertConversations(response.result!.conversations);
        for (final conv in response.result!.conversations) {
          await syncStatusService.upsertSyncStatus(module: 'conversation', conversationId: conv.conversationId, version: conv.version);
        }
      }
    }
  }
}

final conversationMetaSync = ConversationMetaSync();
