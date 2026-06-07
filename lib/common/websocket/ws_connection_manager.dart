import 'package:beaver/common/websocket/index.dart';
import 'package:beaver/core/message/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/ws/ws.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// WebSocket 连接管理器
///
/// 职责：协调 WebSocket 连接和消息管理
/// - 管理 WebSocket 连接生命周期
/// - 连接消息管理器处理业务消息
class WsConnectionManager {
  WsClient? _wsClient;
  MessageManager get _messageManager => getIt<MessageManager>();

  Future<void> connectWithToken(String token) async {
    disconnect();
    
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
    _wsClient!.connect();
  }

  void disconnect() {
    _wsClient?.dispose();
    _wsClient = null;
    getIt<WsStore>().setDisconnected();
  }

  void send(Map<String, dynamic> data) {
    _wsClient?.send(data);
  }

  /// 唤醒检查并自动重连
  void onAppResume() {
    _wsClient?.resume();
  }
}
