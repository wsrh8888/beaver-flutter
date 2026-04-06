/// 通话消息接收器
class CallMessageReceiver {
  void processCallMessage(Map<String, dynamic> wsMessage) {
    final data = wsMessage['data'] as Map<String, dynamic>?;
    print('[CallMessageReceiver] 处理通话消息: $data');
    // TODO: 实现通话消息处理逻辑
  }
}

// Removed global callMessageReceiver
