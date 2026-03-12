import 'package:beaver/application/message_manager/message_manager.dart';

import 'ws_manager.dart';

/// 登录后建连、登出断开、对外 send (对标 desktop 建连 + MessageManager 回调挂接)
class WsConnectionManager {
  WsManager? _ws;
  final MessageManager _messageManager = MessageManager();

  void connectWithToken(String token) {
    disconnect();
    _ws = WsManager.fromEnv(
      token,
      onConnect: () => _messageManager.onWsConnect(),
      onMessage: (data) => _messageManager.handleMessage(data),
      onConnecting: () => _messageManager.onWsConnecting(),
      onDisconnect: () => _messageManager.onWsDisconnect(),
      onError: (e) => _messageManager.onWsError(e),
    );
    _ws!.connect();
  }

  void disconnect() {
    _ws?.dispose();
    _ws = null;
  }

  void send(Map<String, dynamic> data) {
    _ws?.send(data);
  }
}
