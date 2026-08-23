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

import 'dart:async';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/chat/conversation.dart';
import 'package:beaver/core/database/services/chat/user_conversation.dart';
import 'package:beaver/api/chat.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:drift/drift.dart';

/// 用户会话业务逻辑 (对标 PC business/chat/user-conversation.ts)
class UserConversationBusiness {
  final _conversationService = getIt<ChatConversationService>();
  final _userConversationService = getIt<ChatUserConversationService>();

  /**
   * 按版本号同步用户会话设置 (对标 PC syncUserConversationByVersion)
   */
  Future<void> syncUserConversationByVersion(
    String userId,
    String conversationId,
    int version,
  ) async {
    try {
      final response = await getUserConversationSettingsListByIdsApi(
        IGetUserConversationSettingsListByIdsReq(
          conversationIds: [conversationId],
        ),
      );

      if (response.code == 0 && response.result != null) {
        final settings = response.result!.userConversationSettings;
        for (final s in settings) {
          await _userConversationService.upsert(
            ChatUserConversationsCompanion(
              userId: Value(s.userId),
              conversationId: Value(s.conversationId),
              isHidden: Value(s.isHidden ? 1 : 0),
              isPinned: Value(s.isPinned ? 1 : 0),
              isMuted: Value(s.isMuted ? 1 : 0),
              userReadSeq: Value(s.userReadSeq),
              version: Value(s.version),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            ),
          );
        }
        // 同步成功后通知会话列表更新
        getIt<ConversationBusiness>().notifyConversationUpdate();
      }
    } catch (e) {
      print('[UserConversationBusiness] syncUserConversationByVersion failed: $e');
    }
  }

  /**
   * 处理用户会话表更新通知 (对标 PC handleTableUpdates)
   */
  Future<void> handleTableUpdates(String userId, String conversationId, int version) async {
    // 简单起见，目前直接同步，后续可按 PC 端逻辑实现队列
    await syncUserConversationByVersion(userId, conversationId, version);
  }

  Future<void> markAsRead(String conversationId) async {
    final meta = await _conversationService.getConversationById(conversationId);
    if (meta == null) return;

    final maxSeq = meta.maxSeq;
    print('[UserConversationBusiness] 标记已读: conv=$conversationId, seq=$maxSeq');

    await _userConversationService.markAsRead(conversationId, maxSeq);

    // 通知 UI
    getIt<ConversationBusiness>().notifyConversationUpdate();

    // 同步到服务端
    try {
      await updateReadSeqApi(
        IUpdateReadSeqReq(conversationId: conversationId, readSeq: maxSeq),
      );
    } catch (e) {
      print('[UserConversationBusiness] 离线同步已读状态失败: $e');
    }
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    await _userConversationService.togglePinConversation(
      conversationId,
      isPinned,
    );
    
    getIt<ConversationBusiness>().notifyConversationUpdate();

    try {
      await pinnedChatApi(
        IPinnedChatReq(conversationId: conversationId, isPinned: isPinned),
      );
    } catch (e) {
      print('[UserConversationBusiness] 同步置顶状态失败: $e');
    }
  }

  Future<void> toggleMuteChat(String conversationId, bool isMuted) async {
    await _userConversationService.toggleMuteConversation(
      conversationId,
      isMuted,
    );

    getIt<ConversationBusiness>().notifyConversationUpdate();

    try {
      await muteChatApi(
        IMuteChatReq(conversationId: conversationId, isMuted: isMuted),
      );
    } catch (e) {
      print('[UserConversationBusiness] 同步免打扰状态失败: $e');
    }
  }
}
