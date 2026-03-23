import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';

/// 用户会话设置同步器
class UserConversationSync {
  /// 检查并同步用户会话设置
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地同步时间戳
      final localCursor = await datasyncService.get('chat_user_conversations');
      final lastSyncTime = localCursor?.updatedAt ?? 0;

      // 获取服务器上变更的用户会话设置版本信息
      final response = await datasyncGetSyncChatUserConversationsApi(
        IGetSyncChatUserConversationsReq(since: lastSyncTime),
      );
      if (response.code != 0 || response.result == null) {
        // print('[UserConversationSync] 获取会话设置版本失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要更新的会话
      final needUpdateConversations =
          await _compareAndFilterUserConversationVersions(
            syncStatusService,
            response.result!.userConversationVersions,
          );

      if (needUpdateConversations.isNotEmpty) {
        // 有变更的用户会话设置，需要同步数据
        await _syncUserConversationSettings(needUpdateConversations);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'chat_user_conversations',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      // print('[UserConversationSync] 用户会话设置同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的会话信息
  Future<List<IUserConversationVersionItem>>
  _compareAndFilterUserConversationVersions(
    ChatSyncStatusService syncStatusService,
    List<IUserConversationVersionItem> userConversationVersions,
  ) async {
    if (userConversationVersions.isEmpty) return [];

    // 提取所有变更的会话ID
    final conversationIds = userConversationVersions
        .map((item) => item.conversationId)
        .toList();

    // 查询本地已存在的用户会话版本状态
    final localVersions = await syncStatusService.getModuleVersions(
      'user_conversation',
      conversationIds,
    );
    final localVersionMap = {
      for (var v in localVersions) v.conversationId: v.version,
    };

    // 过滤出需要更新的会话信息（本地不存在或版本号更旧的数据）
    return userConversationVersions.where((conversation) {
      final localVersion = localVersionMap[conversation.conversationId] ?? 0;
      return localVersion < conversation.version;
    }).toList();
  }

  /// 同步用户会话设置数据
  Future<void> _syncUserConversationSettings(
    List<IUserConversationVersionItem> conversationsWithVersions,
  ) async {
    final chatService = getIt<ChatUserConversationService>();
    final syncStatusService = getIt<ChatSyncStatusService>();

    // 提取会话ID列表
    final conversationIds = conversationsWithVersions
        .map((item) => item.conversationId)
        .toList();

    // 分批获取用户会话设置数据
    const batchSize = 50;
    for (int i = 0; i < conversationIds.length; i += batchSize) {
      final batchIds = conversationIds.sublist(
        i,
        (i + batchSize > conversationIds.length)
            ? conversationIds.length
            : i + batchSize,
      );

      final response = await getUserConversationSettingsListByIdsApi(
        IGetUserConversationSettingsListByIdsReq(conversationIds: batchIds),
      );
      if (response.code == 0 &&
          response.result != null &&
          response.result!.userConversationSettings.isNotEmpty) {
        final settings = response.result!.userConversationSettings
            .map(
              (uc) => ChatUserConversationsCompanion(
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
            )
            .toList();

        // 批量插入用户会话关系数据
        await chatService.batchCreate(settings);

        // 更新同步状态
        for (final setting in response.result!.userConversationSettings) {
          await syncStatusService.upsertSyncStatus(
            module: 'user_conversation',
            conversationId: setting.conversationId,
            version: setting.version,
          );
        }
      }
    }
  }
}

final userConversationSync = UserConversationSync();
