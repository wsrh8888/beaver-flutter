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

final _logger = Logger('db-chat-conversation');

class ChatConversationService extends BaseService {
  const ChatConversationService();

  /// 创建单个会话
  Future<void> create(ChatConversationsCompanion conversation) async {
    try {

    await db.into(db.chatConversations).insert(conversation);
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.create 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// upsert单个会话（插入或更新）
  Future<void> upsert(ChatConversationsCompanion conversation) async {
    try {

    final conversationId = conversation.conversationId.value;
    final existing = await (db.select(db.chatConversations)
          ..where((t) => t.conversationId.equals(conversationId))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.chatConversations)
            ..where((t) => t.conversationId.equals(conversationId)))
          .write(conversation);
    } else {
      await db.into(db.chatConversations).insert(conversation);
    }
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建会话（支持插入或更新）
  Future<void> batchCreate(List<ChatConversationsCompanion> conversations) async {
    try {
    _logger.info({'text':'ChatConversationService.batchCreate 开始执行','data':{}});

    if (conversations.isEmpty) return;
    for (final conversation in conversations) {
      await upsert(conversation);
    }
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取所有会话（本地数据库场景，支持分页）
  Future<List<ChatConversation>> getAllConversations({int? page, int? limit}) async {
    try {
    _logger.info({'text':'ChatConversationService.getAllConversations 开始执行','data':{}});

    var query = db.select(db.chatConversations);

    if (limit != null && page != null) {
      final offset = (page - 1) * limit;
      query = query..limit(limit, offset: offset);
    }

    return query.get();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.getAllConversations 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据会话ID列表批量获取会话元数据（包含最后消息）
  Future<List<ChatConversation>> getConversationsByIds(List<String> conversationIds) async {
    try {

    if (conversationIds.isEmpty) {
      return [];
    }
    return (db.select(db.chatConversations)..where((t) => t.conversationId.isIn(conversationIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.getConversationsByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据会话ID获取单个会话元数据
  Future<ChatConversation?> getConversationById(String conversationId) async {
    try {

    return (db.select(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.getConversationById 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据类型获取会话（纯数据库查询）
  Future<List<ChatConversation>> getConversationsByType(int type) async {
    try {

    return (db.select(db.chatConversations)..where((t) => t.type.equals(type))).get();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.getConversationsByType 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新会话的最后消息
  Future<void> updateLastMessage(String conversationId, String lastMessage, {int? maxSeq}) async {
    try {

    await (db.update(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).write(
      ChatConversationsCompanion(
        lastMessage: Value(lastMessage),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        maxSeq: maxSeq != null ? Value(maxSeq) : const Value.absent(),
      ),
    );
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.updateLastMessage 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取会话列表（按更新时间降序）
  Future<List<ChatConversation>> getConversations() async {
    try {

    return (db.select(db.chatConversations)..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])).get();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.getConversations 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 删除会话
  Future<void> deleteConversation(String conversationId) async {
    try {

    await (db.delete(db.chatConversations)..where((t) => t.conversationId.equals(conversationId))).go();
    } catch (e, st) {
      _logger.warn({'text':'ChatConversationService.deleteConversation 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
