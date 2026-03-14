/// 通话消息接收器
class CallMessageReceiver {
  void processCallMessage(Map<String, dynamic> data) {
    print('[CallMessageReceiver] 处理通话消息: $data');
    // TODO: 实现通话消息处理逻辑
  }
}

final callMessageReceiver = CallMessageReceiver();