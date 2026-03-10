import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../sync/sync_manager.dart';
import 'ws_message_handler.dart';

/// WebSocket 链路管理器 (对标 Desktop WsManager)
class WsManager {
  WebSocketChannel? _channel;
  final String wsUrl;
  final String token;

  // 定时器
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isConnecting = false;

  WsManager({required this.wsUrl, required this.token});

  /// 建立连接
  void connect() {
    if (_isConnecting || _channel != null) return;
    _isConnecting = true;

    print('[WS] 正在连接: $wsUrl');
    
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$wsUrl?token=$token'), // 开发版可直接透传 Token 握手
      );

      _channel!.stream.listen(
        (message) => _onMessageReceived(message),
        onDone: _onDisconnected,
        onError: _onConnectError,
      );

      _startHeartbeat();
      _isConnecting = false;
      print('[WS] 连接建立成功');
      
      // ⚠️ 重点：连接成功后立即触发全局数据增量同步 (Sync Manager)
      SyncManager.instance.startIncrementalSync();
    } catch (e) {
      _onConnectError(e);
    }
  }

  /// 内部处理消息 (调用分发器)
  void _onMessageReceived(dynamic message) {
    print('[WS] 收到消息: $message');
    final Map<String, dynamic> data = jsonDecode(message);
    WsMessageHandler.handle(data);
  }

  /// 发送数据
  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  /// 重连
  void _onDisconnected() {
    print('[WS] 连接已断开，尝试重连...');
    _channel = null;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => connect());
  }

  void _onConnectError(dynamic error) {
    _isConnecting = false;
    _onDisconnected();
  }

  /// 心跳包
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
}
