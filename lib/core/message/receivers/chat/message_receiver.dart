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

import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('receiver-chat-message');

/// 消息接收器 - 处理多表聚合更新 (对标 PC receivers/chat/message-receiver.ts)
class MessageReceiver {
  MessageBusiness get _messageBusiness => getIt<MessageBusiness>();
  ConversationBusiness get _conversationBusiness => getIt<ConversationBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates = (tableUpdatesBody['tableUpdates'] ?? tableUpdatesBody['tables']) as List?;
    if (tableUpdates == null) {
      _logger.warn({'text': '收到消息表更新但 tableUpdates 为空', 'data': {'bodyKeys': tableUpdatesBody.keys.toList()}});
      return;
    }
    _logger.info({'text': '开始处理消息表更新', 'data': {'count': tableUpdates.length}});

    for (final update in tableUpdates) {
      final table = update['table'] as String?;
      final conversationId = update['conversationId']?.toString();
      final userId = update['userId']?.toString();
      final data = update['data'] as List?;

      if (data == null) continue;

      switch (table) {
        case 'messages':
          if (conversationId != null) {
            for (final item in data) {
              final seq = item['seq'] as int?;
              if (seq != null) {
                try {
                  await _messageBusiness.syncMessagesByVersion(conversationId, seq);
                } catch (e) {
                  _logger.warn({'text': '按版本同步消息失败', 'data': {'conversationId': conversationId, 'seq': seq, 'error': e.toString()}});
                }
              }
            }
          }
          break;

        case 'conversations':
          if (conversationId != null) {
            for (final item in data) {
              final version = item['version'] as int?;
              if (version != null) {
                try {
                  await _conversationBusiness.syncConversationByVersion(conversationId, version);
                } catch (e) {
                  _logger.warn({'text': '按版本同步会话失败', 'data': {'conversationId': conversationId, 'version': version, 'error': e.toString()}});
                }
              }
            }
          }
          break;

        case 'user_conversations':
          if (conversationId != null && userId != null) {
            for (final item in data) {
              final version = item['version'] as int?;
              if (version != null) {
                try {
                  await _conversationBusiness.syncUserConversationByVersion(userId, conversationId, version);
                } catch (e) {
                  _logger.warn({'text': '按版本同步用户会话失败', 'data': {'userId': userId, 'conversationId': conversationId, 'version': version, 'error': e.toString()}});
                }
              }
            }
          }
          break;
      }
    }
  }
}

final messageReceiver = MessageReceiver();
