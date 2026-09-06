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

import 'package:beaver/common/websocket/index.dart';
import 'package:beaver/core/message/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/logger/index.dart';

// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('ws-connection');

/// WebSocket 连接管理器
///
/// 职责：协调 WebSocket 连接和消息管理
/// - 管理 WebSocket 连接生命周期
/// - 连接消息管理器处理业务消息
class WsConnectionManager {
  WsClient? _wsClient;
  MessageManager get _messageManager => getIt<MessageManager>();

  Future<void> connectWithToken(String token) async {
    _logger.info({
      'text': '开始建立WebSocket连接',
      'data': {'hasToken': token.isNotEmpty},
    });
    disconnect();
    _logger.info({'text': '已断开旧连接'});

    // 从本地存储或硬件中提取身份和物理指纹
    final userId = StorageUtil.getString('userId') ?? '';
    final deviceId = await StorageUtil.getDeviceId();

    _wsClient = WsClient.fromEnv(
      token,
      userId,
      deviceId,
      onConnect: () => _messageManager.onWsConnect(),
      onMessage: (data) => _messageManager.handleMessage(data),
      onConnecting: () => _messageManager.onWsConnecting(),
      onDisconnect: () => _messageManager.onWsDisconnect(),
      onError: (e) => _messageManager.onWsError(e),
    );
    _logger.info({
      'text': '已创建WS客户端，发起连接',
      'data': {
        'hasUserId': userId.isNotEmpty,
        'hasDeviceId': deviceId.isNotEmpty,
      },
    });
    _wsClient!.connect();
  }

  void disconnect() {
    _logger.info({'text': '主动断开WebSocket连接'});
    _wsClient?.dispose();
    _wsClient = null;
    getIt<WsStore>().setDisconnected();
  }

  void send(Map<String, dynamic> data) {
    _logger.info({
      'text': '发送WS消息',
      'data': {'command': data['command']},
    });
    _wsClient?.send(data);
  }

  /// 唤醒检查并自动重连
  void onAppResume() {
    _logger.info({'text': '应用回到前台，检查并自动重连'});
    _wsClient?.resume();
  }
}
