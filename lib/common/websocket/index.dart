import 'dart:async';
import 'dart:convert';
import 'package:beaver/common/logger/index.dart';
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
  final Logger _logger = Logger('ws');
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
  bool _isDisposed = false;

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
  }) => WsClient(
    wsUrl: env_config.wsUrl,
    token: token,
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
      _logger.info({'text': '开始建立WS连接', 'url': wsUrl});
      final channel = WebSocketChannel.connect(
        Uri.parse('$wsUrl?token=$token'),
      );

      // 等待握手完成 (这是大厂和标准框架最推荐的信号)
      await channel.ready;

      _channel = channel;
      _channel!.stream.listen(
        _onMessageReceived,
        onDone: _onDisconnected,
        onError: _onConnectError,
      );

      _startHeartbeat();
      _isConnecting = false;
      _logger.info({'text': 'WS连接已在握手完成后确认'});

      // 握手成功后才触发 onConnect
      onConnect?.call();
    } catch (e) {
      _isConnecting = false;
      _logger.error({'text': 'WS连接或握手异常', 'error': e.toString()});
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
    _logger.info({'text': 'WS连接断开'});
    onDisconnect?.call();
    _channel = null;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    if (_isDisposed) return;
    _logger.info({'text': '5秒后尝试重连'});
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect());
  }

  void _onConnectError(dynamic error) {
    _logger.error({'text': 'WS流错误', 'error': error.toString()});
    // 只有在 channel 还没关闭前报的错才处理，防止循环
    if (_channel != null) {
      _onDisconnected();
    } else {
      _isConnecting = false;
    }
    onError?.call(error);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      send({
        'command': 'HEARTBEAT',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
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
      // 尝试发送立即心跳，如果连接已断开但系统还未上报，报错会触发重连逻辑
      try {
        send({
          'command': 'HEARTBEAT',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'action': 'RESUME',
        });
      } catch (_) {
        _onDisconnected();
      }
    }
  }
}
