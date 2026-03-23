import 'package:beaver/common/websocket/index.dart';
import 'package:beaver/core/message/index.dart';
import 'package:beaver/di/injection.dart';

/// WebSocket 连接管理器
/// 
/// 职责：协调 WebSocket 连接和消息管理
/// - 管理 WebSocket 连接生命周期
/// - 连接消息管理器处理业务消息
class WsConnectionManager {
  WsClient? _wsClient;
  MessageManager get _messageManager => getIt<MessageManager>();

  void connectWithToken(String token) {
    disconnect();
    _wsClient = WsClient.fromEnv(
      token,
      onConnect: () => _messageManager.onWsConnect(),
      onMessage: (data) => _messageManager.handleMessage(data),
      onConnecting: () => _messageManager.onWsConnecting(),
      onDisconnect: () => _messageManager.onWsDisconnect(),
      onError: (e) => _messageManager.onWsError(e),
    );
    _wsClient!.connect();
  }

  void disconnect() {
    _wsClient?.dispose();
    _wsClient = null;
  }

  void send(Map<String, dynamic> data) {
    _wsClient?.send(data);
  }
}
