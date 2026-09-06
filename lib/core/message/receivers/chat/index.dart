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

import 'dart:convert';

import './message_receiver.dart';
import './conversation_receiver.dart';
import './user_conversation_receiver.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/core/business/chat/message.dart';

/// 聊天消息路由器 (对标 PC receivers/chat/index.ts)
/// 根据消息类型路由到对应的接收器
// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('chat-message-router');

class ChatMessageRouter {
  final _messageReceiver = messageReceiver;
  final _conversationReceiver = conversationReceiver;
  final _userConversationReceiver = userConversationReceiver;

  /**
   * 处理聊天消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processChatMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      _logger.warn({'text': '收到路由消息但缺少data字段', 'data': {'wsMessage': wsMessage}});
      return;
    }

    final type = data['type'] as String?;
    final body = _parseBody(data['body']);
    final conversationId = data['conversationId'] as String?;

    _logger.info({
      'text': '收到路由消息',
      'data': {'type': type, 'conversationId': conversationId, 'hasBody': body != null},
    });

    if (type == null || body == null) return;

    switch (type) {
      // 聚合消息更新 - 包含所有表的更新
      case 'chat_conversation_message_receive':
        _logger.info({'text': '命中聚合消息同步', 'data': {'type': type, 'conversationId': conversationId}});
        await _messageReceiver.handleTableUpdates(body);
        break;

      // 会话相关的更新
      case 'chat_conversation_meta_receive':
        await _conversationReceiver.handleTableUpdates(body);
        break;

      // 用户会话相关的更新
      case 'chat_user_conversation_receive':
        await _userConversationReceiver.handleTableUpdates(body);
        break;

      // 处理常规消息接收 (私聊/群聊新消息)
      case 'private_message_receive':
      case 'group_message_receive':
      case 'private_message_sync':
      case 'group_message_sync':
        await getIt<MessageBusiness>().handleNewWSMessage(data);
        if (type.contains('sync')) {
          final messageId = body['messageId'] as String?;
          if (messageId != null) {
            getIt<MessageBusiness>().clearTimers([messageId]);
          }
        }
        break;

      // 处理发送成功 ACK
      case 'private_message_send_ack':
      case 'group_message_send_ack':
        final messageId = body['messageId'] as String?;
        if (messageId != null) {
          getIt<MessageBusiness>().clearTimers([messageId]);
        }
        break;

      case 'chat_message_media_receive':
        _handleMessageMediaUpdate(body);
        break;

      default:
        _logger.warn({'text': '未处理的消息类型', 'data': {'type': type}});
    }
  }

  Map<String, dynamic>? _parseBody(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return null;
  }

  void _handleMessageMediaUpdate(Map<String, dynamic> body) {
    final tableUpdates = body['tableUpdates'] as List?;
    if (tableUpdates == null) {
      _logger.warn({'text': '消息媒体更新缺少 tableUpdates', 'data': {'body': body}});
      return;
    }

    final messageIds = <String>[];
    for (final update in tableUpdates) {
      if (update is! Map) {
        continue;
      }
      if (update['table'] != 'message_medias') {
        continue;
      }
      final data = update['data'] as List?;
      if (data == null) {
        continue;
      }
      for (final item in data) {
        if (item is! Map) {
          continue;
        }
        final ids = item['messageIds'] as List?;
        if (ids == null) {
          continue;
        }
        messageIds.addAll(ids.whereType<String>());
      }
    }

    if (messageIds.isNotEmpty) {
      _logger.info({
        'text': '收到消息媒体已听推送',
        'data': {'count': messageIds.length, 'messageIds': messageIds},
      });
      getIt<MessageMediaStore>().merge(messageIds);
    }
  }
}

final chatMessageRouter = ChatMessageRouter();
