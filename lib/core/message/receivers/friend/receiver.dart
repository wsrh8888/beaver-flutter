/// 好友消息接收器
/// 
/// 职责：处理好友相关的 WebSocket 消息
class FriendMessageReceiver {
  void processFriendMessage(Map<String, dynamic> content) {
    // TODO: 处理好友消息
    print('[FriendReceiver] 收到消息: $content');
  }
}