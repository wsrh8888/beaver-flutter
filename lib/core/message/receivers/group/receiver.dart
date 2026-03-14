/// 群组消息接收器
/// 
/// 职责：处理群组相关的 WebSocket 消息
class GroupMessageReceiver {
  void processGroupMessage(Map<String, dynamic> content) {
    // TODO: 处理群组消息
    print('[GroupReceiver] 收到消息: $content');
  }
}