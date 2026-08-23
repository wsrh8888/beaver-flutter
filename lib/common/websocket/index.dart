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
import 'dart:convert';
import 'dart:io';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/app/app.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:beaver/common/config/index.dart' as env_config;

/**
 * WebSocket 客户端服务
 *
 * 职责：纯 WebSocket 连接管理，与业务无关
 * - 建立/断开连接 (携带 GUID 指纹)
 * - 401 鉴权失效自愈
 * - 心跳维护 (PING/PONG)
 */
class WsClient {
  final Logger _logger = Logger('ws');
  WebSocketChannel? _channel;
  final String wsUrl;
  final String token;
  final String userId;
  final String deviceId;

  void Function()? onConnect;
  void Function(Map<String, dynamic>)? onMessage;
  void Function()? onConnecting;
  void Function()? onDisconnect;
  void Function(dynamic)? onError;

  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _pongTimeoutTimer;

  bool _isConnecting = false;
  bool _isDisposed = false;

  // 心跳间隔
  static const _heartbeatInterval = Duration(seconds: 30);
  // PONG 超时时间
  static const _pongTimeout = Duration(seconds: 15);

  WsClient({
    required this.wsUrl,
    required this.token,
    required this.userId,
    required this.deviceId,
    this.onConnect,
    this.onMessage,
    this.onConnecting,
    this.onDisconnect,
    this.onError,
  });

  factory WsClient.fromEnv(
    String token,
    String userId,
    String deviceId, {
    void Function()? onConnect,
    void Function(Map<String, dynamic>)? onMessage,
    void Function()? onConnecting,
    void Function()? onDisconnect,
    void Function(dynamic)? onError,
  }) => WsClient(
    wsUrl: env_config.wsUrl,
    token: token,
    userId: userId,
    deviceId: deviceId,
    onConnect: onConnect,
    onMessage: onMessage,
    onConnecting: onConnecting,
    onDisconnect: onDisconnect,
    onError: onError,
  );

  Future<void> connect() async {
    if (_isConnecting || _channel != null) return;
    _isConnecting = true;
    onConnecting?.call();
    try {
      // 对齐大厂实践：精准识别平台
      final String platform = Platform.isIOS ? 'ios' : 'android';

      // 构造携带三方校验参数的 URI
      final uri = Uri.parse(wsUrl).replace(
        queryParameters: {
          'token': token,
          'userId': userId,
          'platform': platform,
          'deviceId': deviceId,
        },
      );

      _logger.info({'text': '开始建立安全WS连接', 'url': uri.toString()});

      final customChannel = IOWebSocketChannel.connect(
        uri,
        headers: {'User-Agent': AppConfig.userAgent},
      );

      // 等待握手完成。如果服务端返回 401，这里会抛出 Exception
      await customChannel.ready;

      _channel = customChannel;
      _channel!.stream.listen(
        _onMessageReceived,
        onDone: _onDisconnected,
        onError: _onConnectError,
      );

      _isConnecting = false;
      _startHeartbeat();

      _logger.info({'text': 'WS安全连接已成功建立', 'platform': platform});

      // 握手成功后才触发 onConnect
      onConnect?.call();
    } catch (e) {
      _isConnecting = false;
      final errorStr = e.toString();
      _logger.error({'text': 'WS物理连接或鉴权异常', 'error': errorStr});

      // 核心安全自愈逻辑：检测到 401 鉴权失效，自动强制登出
      if (errorStr.contains('401')) {
        _logger.warn({'text': '检测到移动端登录鉴权失效(401)，触发自动登出'});
        _isDisposed = true; // 停止无限重连
        getIt<AppStore>().logout();
        return;
      }

      _onConnectError(e);
    }
  }

  void _onMessageReceived(dynamic message) {
    try {
      final Map<String, dynamic> data = message is String
          ? Map<String, dynamic>.from(jsonDecode(message) as Map)
          : Map<String, dynamic>.from(message as Map);

      final String? command = data['command'] as String?;

      // 1. 处理控制帧 (服务端发来的控制帧是扁平结构)
      if (command == 'PONG') {
        _pongTimeoutTimer?.cancel();
        return;
      }

      if (command == 'PING') {
        _sendPong(
          data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        );
        return;
      }

      if (command == 'ACK') {
        _logger.info({'text': '收到服务端回复(ACK)', 'messageId': data['messageId']});
        return;
      }

      // 2. 业务消息转发给上层
      if (onMessage != null) {
        onMessage!(data);
      }
    } catch (e) {
      _logger.error({
        'text': '解析WS消息失败',
        'error': e.toString(),
        'raw': message,
      });
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
      return;
    }
    _logger.warn({
      'text': 'WS 未连接，消息未发出',
      'command': data['command'],
      'messageId': (data['content'] as Map?)?['messageId'],
    });
  }

  void _sendPing() {
    // 客户端发出的 PING 需要符合 WsMessage 结构，因为服务端在 HandleWebSocketMessages 中解析 WsMessage
    send({
      'command': 'PING',
      'content': {'timestamp': DateTime.now().millisecondsSinceEpoch},
    });

    // 开启 PONG 超时检测
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = Timer(_pongTimeout, () {
      _logger.warn({'text': '心跳超时(PONG未收到)，主动断开并准备重连'});
      _reconnect();
    });
  }

  void _sendPong(int timestamp) {
    // 回复服务端的 PING，使用扁平的 WsControlFrame 结构
    send({'command': 'PONG', 'timestamp': timestamp});
  }

  void _onDisconnected() {
    _logger.info({'text': 'WS连接断开'});
    _reconnect();
  }

  void _reconnect() {
    _channel?.sink.close();
    _channel = null;
    _stopHeartbeat();
    _pongTimeoutTimer?.cancel();

    onDisconnect?.call();

    if (_isDisposed) return;

    _reconnectTimer?.cancel();
    _logger.info({'text': '5秒后尝试重连'});
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect());
  }

  void _onConnectError(dynamic error) {
    _logger.error({'text': 'WS流错误', 'error': error.toString()});
    _reconnect();
    onError?.call(error);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      _sendPing();
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
  }

  void dispose() {
    _isDisposed = true;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }

  /// 唤醒时检查连接并重新激活
  void resume() {
    if (_channel == null) {
      connect();
    } else {
      // 立即发送一个心跳，检查连接是否依然可用
      _sendPing();
    }
  }
}
