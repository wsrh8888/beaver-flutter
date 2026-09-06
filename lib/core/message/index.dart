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

import 'package:beaver/core/datasync/manager.dart' show syncManager;
import 'package:beaver/store/app/app.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/message/receivers/call/call.dart';
import 'package:beaver/core/message/receivers/chat/index.dart';
import 'package:beaver/core/message/receivers/friend/index.dart';
import 'package:beaver/core/message/receivers/group/index.dart';
import 'package:beaver/core/message/receivers/notification/index.dart';
import 'package:beaver/core/message/receivers/user/index.dart';
import 'package:beaver/common/logger/index.dart';

// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('message');

/// Message manager: ensures sync-first and ordered message dispatch.
class MessageManager {
  bool _isDataSyncing = false;
  final List<Map<String, dynamic>> _messageQueue = [];
  bool _isQueueDraining = false;

  final ChatMessageRouter _chatRouter = chatMessageRouter;
  final FriendMessageRouter _friendRouter = friendMessageRouter;
  final GroupMessageRouter _groupRouter = groupMessageRouter;
  final NotificationMessageRouter _notificationRouter =
      notificationMessageRouter;
  final UserMessageRouter _userRouter = userMessageRouter;
  final CallMessageReceiver _callReceiver = CallMessageReceiver();

  Future<void> onWsConnect() async {
    _logger.info({'text': 'WS已连接，开始执行数据同步'});
    getIt<WsStore>().setSyncing();
    try {
      _isDataSyncing = true;
      final isBackground = getIt<AppStore>().state.isInitComplete;
      _logger.info({
        'text': '触发全量数据同步',
        'data': {'isBackground': isBackground},
      });
      await syncManager.autoSync(isBackground: isBackground);
      _logger.info({'text': '数据同步完成，准备派发消息队列'});
    } finally {
      _isDataSyncing = false;
      getIt<WsStore>().setConnected();
      _startDrainQueue();
    }
  }

  void onWsConnecting() {
    getIt<WsStore>().setConnecting();
  }

  void onWsDisconnect() {
    getIt<WsStore>().setDisconnected();
  }

  void onWsError(dynamic error) {
    _logger.error({'text': 'WS连接错误', 'data': {'error': error.toString()}});
    getIt<WsStore>().setDisconnected();
  }

  void handleMessage(Map<String, dynamic> data) {
    _logger.info({'text': '收到了ws消息', 'data': data});
    _messageQueue.add(data);
    if (_isDataSyncing) return;
    _startDrainQueue();
  }

  void _startDrainQueue() {
    if (_isQueueDraining) return;
    _isQueueDraining = true;
    _drainQueue();
  }

  Future<void> _drainQueue() async {
    try {
      while (!_isDataSyncing && _messageQueue.isNotEmpty) {
        final message = _messageQueue.removeAt(0);
        try {
          await _processMessage(message);
        } catch (e, stack) {
          _logger.error({
            'text': '消息分发处理异常',
            'data': {
              'command': message['command'],
              'error': e.toString(),
              'stack': stack.toString(),
            },
          });
        }
      }
    } finally {
      _isQueueDraining = false;
      if (!_isDataSyncing && _messageQueue.isNotEmpty) {
        _startDrainQueue();
      }
    }
  }

  Future<void> _processMessage(Map<String, dynamic> wsMessage) async {
    final command = wsMessage['command'] as String?;
    final content = wsMessage['content'] as Map<String, dynamic>?;
    if (content == null) return;

    switch (command) {
      case 'CHAT_MESSAGE':
        await _chatRouter.processChatMessage(content);
        break;
      case 'FRIEND_OPERATION':
        await _friendRouter.processFriendMessage(content);
        break;
      case 'GROUP_OPERATION':
        await _groupRouter.processGroupMessage(content);
        break;
      case 'NOTIFICATION':
        await _notificationRouter.processNotificationMessage(content);
        break;
      case 'USER_PROFILE':
        await _userRouter.processUserMessage(content);
        break;
      case 'CALL':
      case 'CALL_OPERATION':
        _callReceiver.processCallMessage(content);
        break;
      case 'SYSTEM_MESSAGE':
      case 'HEARTBEAT':
      default:
        break;
    }
  }
}
