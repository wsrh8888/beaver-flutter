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

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-chat-user_conversation');

class ChatUserConversationService extends BaseService {
  const ChatUserConversationService();

  /// 创建单个用户会话设置
  Future<void> create(ChatUserConversationsCompanion setting) async {
    try {

    await db.into(db.chatUserConversations).insert(setting);
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.create 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// upsert单个用户会话设置（插入或更新）
  Future<void> upsert(ChatUserConversationsCompanion setting) async {
    try {

    final conversationId = setting.conversationId.value;
    final existing = await (db.select(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.chatUserConversations)
            ..where((t) => t.conversationId.equals(conversationId)))
          .write(setting);
    } else {
      await db.into(db.chatUserConversations).insert(setting);
    }
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建用户会话设置（支持插入或更新）
  Future<void> batchCreate(List<ChatUserConversationsCompanion> settings) async {
    try {
    _logger.info({'text':'ChatUserConversationService.batchCreate 开始执行','data':{}});

    if (settings.isEmpty) return;

    for (final setting in settings) {
      await upsert(setting);
    }
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据会话ID获取用户会话设置
  Future<ChatUserConversation?> getByConversationId(String conversationId) async {
    try {

    return (db.select(db.chatUserConversations)..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.getByConversationId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据用户ID获取所有用户会话设置
  Future<List<ChatUserConversation>> getByUserId(String userId) async {
    try {

    return (db.select(db.chatUserConversations)..where((t) => t.userId.equals(userId))).get();
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.getByUserId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 置顶/取消置顶会话
  Future<void> togglePinConversation(String conversationId, bool isPinned) async {
    try {

    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          isPinned: Value(isPinned ? 1 : 0),
        ));
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.togglePinConversation 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 免打扰/取消免打扰
  Future<void> toggleMuteConversation(String conversationId, bool isMuted) async {
    try {

    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          isMuted: Value(isMuted ? 1 : 0),
        ));
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.toggleMuteConversation 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 标记已读
  Future<void> markAsRead(String conversationId, int userReadSeq) async {
    try {

    await (db.update(db.chatUserConversations)
          ..where((t) => t.conversationId.equals(conversationId)))
        .write(ChatUserConversationsCompanion(
          userReadSeq: Value(userReadSeq),
        ));
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.markAsRead 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 删除用户会话设置
  Future<void> delete(String conversationId) async {
    try {

    await (db.delete(db.chatUserConversations)..where((t) => t.conversationId.equals(conversationId))).go();
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.delete 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量删除用户会话设置
  Future<void> batchDelete(List<String> conversationIds) async {
    try {
    _logger.info({'text':'ChatUserConversationService.batchDelete 开始执行','data':{}});

    if (conversationIds.isEmpty) {
      return;
    }
    await (db.delete(db.chatUserConversations)..where((t) => t.conversationId.isIn(conversationIds))).go();
    } catch (e, st) {
      _logger.warn({'text':'ChatUserConversationService.batchDelete 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
