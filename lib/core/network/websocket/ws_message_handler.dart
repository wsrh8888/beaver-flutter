import '../../sync/sync_manager.dart';

/// WebSocket 消息分发器 (对标 Desktop handleIncomingMessage)
class WsMessageHandler {
  /// 全局处理入口
  static void handle(Map<String, dynamic> data) {
    final String? command = data['command'];
    
    switch (command) {
      case 'MSG_NEW': // 新消息提醒
        _handleNewMessage(data);
        break;
      case 'MSG_READ_RECEIPT': // 已读回执
        _handleReadReceipt(data);
        break;
      case 'SYNC_TRIGGER': // 强制触发同步
        _handleSyncTrigger();
        break;
      case 'HEARTBEAT_ACK': // 心跳确认
        print('[WS] Received Heartbeat ACK');
        break;
      default:
        print('[WS] Unknown command: $command');
    }
  }

  /// 处理普通聊天新消息
  static void _handleNewMessage(Map<String, dynamic> data) {
    // ⚠️ 核心：所有消息统一交给 SyncManager 处理
    // SyncManager 会根据当前是否正在“大同步”来决定是“直接落库”还是“进队列缓冲”
    SyncManager.instance.onIncomingWsMessage(data);
  }

  /// 已读回执处理
  static void _handleReadReceipt(Map<String, dynamic> data) {
    // TODO: 更新本地库消息状态为已读
    print('[WS] Handling Read Receipt: $data');
  }

  /// 强制同步
  static void _handleSyncTrigger() {
    SyncManager.instance.startIncrementalSync();
  }
}
