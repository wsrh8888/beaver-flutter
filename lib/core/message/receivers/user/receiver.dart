/// 用户消息接收器
/// 
/// 职责：处理用户相关的 WebSocket 消息
class UserMessageReceiver {
  void processUserMessage(Map<String, dynamic> content) {
    // TODO: 处理用户消息
    print('[UserReceiver] 收到消息: $content');
  }
}