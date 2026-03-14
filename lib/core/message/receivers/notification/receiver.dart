/// 通知消息接收器
/// 
/// 职责：处理通知相关的 WebSocket 消息
class NotificationMessageReceiver {
  void processNotificationMessage(Map<String, dynamic> content) {
    // TODO: 处理通知消息
    print('[NotificationReceiver] 收到消息: $content');
  }
}