import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';

/// 用户会话设置同步
class UserConversationSync {
  Future<void> checkAndSync() async {
    print('[UserConversationSync] 开始同步用户会话设置');

    final datasyncService = getIt<DatasyncService>();
    final chatService = getIt<ChatService>();
    final syncStatusService = getIt<ChatSyncStatusService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('chat_user_conversations');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncChatUserConversationsApi(IGetSyncChatUserConversationsReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) {
      print('[UserConversationSync] 获取会话设置版本失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比过滤
    final needUpdate = await _compareAndFilterVersions(syncStatusService, response.result!.userConversationVersions);

    if (needUpdate.isNotEmpty) {
      // 4. 同步具体数据
      await _syncUserConversations(chatService, syncStatusService, needUpdate);
    }

    // 5. 更新游标
    await datasyncService.upsert('chat_user_conversations', -1, serverTimestamp);
    
    print('[UserConversationSync] 用户会话设置同步完成');
  }

  Future<List<IUserConversationVersionItem>> _compareAndFilterVersions(
    ChatSyncStatusService syncStatusService,
    List<IUserConversationVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    final conversationIds = serverVersions.map((e) => e.conversationId).toList();
    final localVersions = await syncStatusService.getModuleVersions('user_conversation', conversationIds);
    final localMap = {for (var v in localVersions) v.conversationId: v.version};

    return serverVersions.where((sv) => (localMap[sv.conversationId] ?? 0) < sv.version).toList();
  }

  Future<void> _syncUserConversations(
    ChatService chatService,
    ChatSyncStatusService syncStatusService,
    List<IUserConversationVersionItem> needUpdate,
  ) async {
    final conversationIds = needUpdate.map((e) => e.conversationId).toList();
    const batchSize = 50;
    for (int i = 0; i < conversationIds.length; i += batchSize) {
      final batchIds = conversationIds.sublist(i, i + batchSize > conversationIds.length ? conversationIds.length : i + batchSize);
      final response = await getUserConversationSettingsListByIdsApi(IGetUserConversationSettingsListByIdsReq(conversationIds: batchIds));
      if (response.code == 0 && response.result != null) {
        await chatService.batchCreateUserConversations(response.result!.userConversationSettings);
        for (final setting in response.result!.userConversationSettings) {
          await syncStatusService.upsertSyncStatus(module: 'user_conversation', conversationId: setting.conversationId, version: setting.version);
        }
      }
    }
  }
}

final userConversationSync = UserConversationSync();
