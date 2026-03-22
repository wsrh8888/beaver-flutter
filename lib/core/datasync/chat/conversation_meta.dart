import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';

/// 会话元数据同步器
class ConversationMetaSync {
  /// 检查并同步会话元数据
  Future<void> checkAndSync() async {
    print('[ConversationMetaSync] 开始同步会话元数据');
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地最后同步时间
      final localCursor = await datasyncService.get('chat_conversations');
      final lastSyncTime = localCursor?.version ?? 0;

      // 获取服务器变更的会话版本信息
      final response = await datasyncGetSyncChatConversationsApi(
        IGetSyncChatConversationsReq(since: lastSyncTime),
      );
      if (response.code != 0 || response.result == null) {
        print('[ConversationMetaSync] 获取会话版本失败: ${response.msg}');
        return;
      }

      final serverTimestamp = response.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的会话
      final needUpdateConversations =
          await _compareAndFilterConversationVersions(
            syncStatusService,
            response.result!.conversationVersions,
          );

      // 处理变更的会话
      if (needUpdateConversations.isNotEmpty) {
        await _syncConversations(needUpdateConversations);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'chat_conversations',
        -1, // 使用时间戳而不是版本号
        serverTimestamp,
      );

      print('[ConversationMetaSync] 会话元数据同步完成');
    } catch (error) {
      print('[ConversationMetaSync] 会话元数据同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的会话信息
  Future<List<IConversationVersionItem>> _compareAndFilterConversationVersions(
    ChatSyncStatusService syncStatusService,
    List<IConversationVersionItem> conversationVersions,
  ) async {
    if (conversationVersions.isEmpty) return [];

    // 提取所有变更的会话ID
    final conversationIds = conversationVersions
        .map((item) => item.conversationId)
        .toList();

    // 查询本地已存在的会话版本状态
    final localVersions = await syncStatusService.getModuleVersions(
      'conversation',
      conversationIds,
    );
    final localVersionMap = {
      for (var v in localVersions) v.conversationId: v.version,
    };

    // 过滤出需要更新的会话信息（本地不存在或版本号更旧的数据）
    return conversationVersions.where((conversation) {
      final localVersion = localVersionMap[conversation.conversationId] ?? 0;
      return localVersion < conversation.version;
    }).toList();
  }

  /// 同步会话数据
  Future<void> _syncConversations(
    List<IConversationVersionItem> conversationsWithVersions,
  ) async {
    final chatService = getIt<ChatConversationService>();
    final syncStatusService = getIt<ChatSyncStatusService>();

    // 提取会话ID列表
    final conversationIds = conversationsWithVersions
        .map((item) => item.conversationId)
        .toList();

    // 分批获取会话数据
    const batchSize = 50;
    for (int i = 0; i < conversationIds.length; i += batchSize) {
      final batchIds = conversationIds.sublist(
        i,
        (i + batchSize > conversationIds.length)
            ? conversationIds.length
            : i + batchSize,
      );

      final response = await getConversationsListByIdsApi(
        IGetConversationsListByIdsReq(conversationIds: batchIds),
      );
      if (response.code == 0 &&
          response.result != null &&
          response.result!.conversations.isNotEmpty) {
        // 批量更新本地会话数据
        for (final conv in response.result!.conversations) {
          await chatService.upsert(
            ChatConversationsCompanion(
              conversationId: Value(conv.conversationId),
              type: Value(conv.conversationType),
              title: Value(conv.title),
              avatar: Value(conv.avatar),
              version: Value(conv.version),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            ),
          );

          // 更新同步状态
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
