import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:beaver/common/config/index.dart' as env_config;

/// WebSocket 客户端服务
/// 
/// 职责：纯 WebSocket 连接管理，与业务无关
/// - 建立/断开连接
/// - 心跳维护
/// - 重连机制
/// - 原始数据收发
class WsClient {
  WebSocketChannel? _channel;
  final String wsUrl;
  final String token;

  void Function()? onConnect;
  void Function(Map<String, dynamic>)? onMessage;
  void Function()? onConnecting;
  void Function()? onDisconnect;
  void Function(dynamic)? onError;

  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isConnecting = false;

  WsClient({
    required this.wsUrl,
    required this.token,
    this.onConnect,
    this.onMessage,
    this.onConnecting,
    this.onDisconnect,
    this.onError,
  });

  factory WsClient.fromEnv(
    String token, {
    void Function()? onConnect,
    void Function(Map<String, dynamic>)? onMessage,
    void Function()? onConnecting,
    void Function()? onDisconnect,
    void Function(dynamic)? onError,
  }) =>
      WsClient(
        wsUrl: env_config.wsUrl,
        token: token,
        onConnect: onConnect,
        onMessage: onMessage,
        onConnecting: onConnecting,
        onDisconnect: onDisconnect,
        onError: onError,
      );

  void connect() {
    if (_isConnecting || _channel != null) return;
    _isConnecting = true;
    onConnecting?.call();
    try {
      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl?token=$token'));
      _channel!.stream.listen(
        _onMessageReceived,
        onDone: _onDisconnected,
        onError: _onConnectError,
      );
      _startHeartbeat();
      _isConnecting = false;
      Future.microtask(() => onConnect?.call());
    } catch (e) {
      _onConnectError(e);
    }
  }

  void _onMessageReceived(dynamic message) {
    final Map<String, dynamic> data = message is String
        ? Map<String, dynamic>.from(jsonDecode(message) as Map)
        : Map<String, dynamic>.from(message as Map);
    if (onMessage != null) {
      onMessage!(data);
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _onDisconnected() {
    onDisconnect?.call();
    _channel = null;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect());
  }

  void _onConnectError(dynamic error) {
    _isConnecting = false;
    onError?.call(error);
    _onDisconnected();
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      send({'command': 'HEARTBEAT', 'timestamp': DateTime.now().millisecondsSinceEpoch});
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
  }

  void dispose() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }

  /// 唤醒时检查连接并重新激活
  void resume() {
    if (_channel == null) {
      connect();
    } else {
      // 尝试发送立即心跳，如果连接已断开但系统还未上报，报错会触发重连逻辑
      try {
        send({
          'command': 'HEARTBEAT',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'action': 'RESUME'
        });
      } catch (_) {
        _onDisconnected();
      }
    }
  }
}
