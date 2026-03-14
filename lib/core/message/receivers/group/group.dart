/// 群组消息接收器
class GroupMessageReceiver {
  void processGroupMessage(Map<String, dynamic> data) {
    print('[GroupMessageReceiver] 处理群组消息: $data');
    // TODO: 实现群组消息处理逻辑
  }
}

final groupMessageReceiver = GroupMessageReceiver();