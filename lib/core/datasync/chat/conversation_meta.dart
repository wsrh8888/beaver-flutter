/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-chat-conversation-meta');

/// 会话元数据同步器
class ConversationMetaSync {
  /// 检查并同步会话元数据
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) {
      _logger.warn({'text': '会话元数据同步跳过：未登录（userId 为空）'});
      return;
    }
    _logger.info({'text': '开始同步会话元数据'});

    try {
      final datasyncService = getIt<DatasyncService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地同步游标（version=-1 表示发现全部变更，对齐 PC）
      final localCursor = await datasyncService.get('chat_conversations');
      final lastSyncVersion = localCursor?.version ?? 0;

      // 获取服务器变更的会话版本信息
      final response = await datasyncGetSyncChatConversationsApi(
        IGetSyncChatConversationsReq(since: lastSyncVersion),
      );
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '获取会话版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
        return;
      }

      final serverTimestamp = response.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的会话
      final needUpdateConversations =
          await _compareAndFilterConversationVersions(
            syncStatusService,
            response.result!.conversationVersions,
          );
      _logger.info({'text': '会话元数据对比完成', 'data': {'needUpdate': needUpdateConversations.length}});

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
      _logger.info({'text': '会话元数据同步完成'});
    } catch (error) {
      _logger.warn({'text': '会话元数据同步异常', 'data': {'error': error.toString()}});
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
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '批量获取会话数据失败', 'data': {'code': response.code, 'msg': response.msg, 'batchCount': batchIds.length}});
        continue;
      }
      if (response.result!.conversations.isNotEmpty) {
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
