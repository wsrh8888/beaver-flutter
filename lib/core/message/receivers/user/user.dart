/// 用户消息接收器
class UserMessageReceiver {
  void processUserMessage(Map<String, dynamic> data) {
    print('[UserMessageReceiver] 处理用户消息: $data');
    // TODO: 实现用户消息处理逻辑
  }
}

final userMessageReceiver = UserMessageReceiver();