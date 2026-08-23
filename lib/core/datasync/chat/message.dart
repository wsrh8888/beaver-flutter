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
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// 消息同步器 - 负责同步聊天消息数据
class MessageSync {
  /// 检查并同步消息数据
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地同步游标（version=-1 表示发现全部变更，对齐 PC）
      final localCursor = await datasyncService.get('chat_messages');
      final lastSyncVersion = localCursor?.version ?? 0;

      // 获取服务器上变更的消息版本信息
      final response = await datasyncGetSyncChatMessagesApi(
        IGetSyncChatMessagesReq(since: lastSyncVersion),
      );
      if (response.code != 0 || response.result == null) {
        // print('[MessageSync] 获取消息摘要失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要同步消息的会话
      final needSyncConversations = await _compareAndFilterMessageVersions(
        syncStatusService,
        response.result!.messageVersions,
      );

      if (needSyncConversations.isNotEmpty) {
        // 有需要同步消息的会话
        await _syncMessagesForConversations(needSyncConversations);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'chat_messages',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      print('[MessageSync] 消息同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要同步消息的会话
  Future<List<_ConversationSeqItem>> _compareAndFilterMessageVersions(
    ChatSyncStatusService syncStatusService,
    List<IChatMessageVersionItem> messageVersions,
  ) async {
    if (messageVersions.isEmpty) return [];

    // 按会话分组获取服务器的最大 seq
    final serverConversationMap = <String, int>{};
    for (final item in messageVersions) {
      final currentSeq = serverConversationMap[item.conversationId] ?? 0;
      if (item.seq > currentSeq) {
        serverConversationMap[item.conversationId] = item.seq;
      }
    }

    final conversationIds = serverConversationMap.keys.toList();
    // 批量查询本地消息同步状态
    final localVersions = await syncStatusService.getModuleVersions(
      'message',
      conversationIds,
    );
    final localVersionMap = {
      for (var v in localVersions) v.conversationId: v.seq,
    };

    final List<_ConversationSeqItem> needSyncConversations = [];
    serverConversationMap.forEach((conversationId, serverSeq) {
      final localSeq = localVersionMap[conversationId] ?? 0;
      if (serverSeq > localSeq) {
        needSyncConversations.add(
          _ConversationSeqItem(conversationId, serverSeq),
        );
      }
    });

    return needSyncConversations;
  }

  /// 同步指定会话的消息数据
  Future<void> _syncMessagesForConversations(
    List<_ConversationSeqItem> conversationsWithSeq,
  ) async {
    final syncStatusService = getIt<ChatSyncStatusService>();

    for (final item in conversationsWithSeq) {
      // 获取本地消息同步状态
      final localSyncStatus = await syncStatusService.getSyncStatus(
        'message',
        item.conversationId,
      );
      final localSeq = localSyncStatus?.seq ?? 0;

      // 同步该会话的消息（从本地seq+1开始到服务器seq）
      await syncConversationMessages(
        item.conversationId,
        localSeq + 1,
        item.serverSeq,
      );

      // 更新消息同步状态
      await syncStatusService.upsertSyncStatus(
        module: 'message',
        conversationId: item.conversationId,
        seq: item.serverSeq,
      );
    }

    final messageStore = getIt<MessageStore>();
    for (final item in conversationsWithSeq) {
      if (messageStore.state.chatHistory.containsKey(item.conversationId)) {
        await messageStore.reloadConversation(item.conversationId);
      }
    }
    getIt<ConversationBusiness>().notifyConversationUpdate();
  }

  /// 同步单个会话的消息
  Future<void> syncConversationMessages(
    String conversationId,
    int fromSeq,
    int toSeq,
  ) async {
    try {
      await _doSyncConversationMessages(conversationId, fromSeq, toSeq);
    } catch (error) {
      print('[MessageSync] 消息同步失败: $error');
    }
  }

  /// 执行单个会话的消息同步
  Future<void> _doSyncConversationMessages(
    String conversationId,
    int fromSeq,
    int toSeq,
  ) async {
    final messageBusiness = getIt<MessageBusiness>();
    int currentSeq = fromSeq;

    while (currentSeq <= toSeq) {
      final response = await chatSyncApi(
        IChatSyncReq(
          conversationId: conversationId,
          fromSeq: currentSeq,
          toSeq: (currentSeq + 99 < toSeq) ? currentSeq + 99 : toSeq,
          limit: 100,
        ),
      );

      if (response.code == 0 &&
          response.result != null &&
          response.result!.messages.isNotEmpty) {
        final apiMessages = response.result!.messages;
        await messageBusiness.applySyncedMessages(apiMessages);
        messageBusiness.clearTimers(
          apiMessages.map((m) => m.messageId).toList(),
        );

        currentSeq = (currentSeq + 99 < toSeq) ? currentSeq + 100 : toSeq + 1;
      } else {
        break;
      }
    }
  }
}

class _ConversationSeqItem {
  final String conversationId;
  final int serverSeq;
  _ConversationSeqItem(this.conversationId, this.serverSeq);
}

final messageSync = MessageSync();
