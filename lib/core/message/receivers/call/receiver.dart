/// 通话消息接收器
/// 
/// 职责：处理音视频通话相关的 WebSocket 消息
class CallMessageReceiver {
  void processCallMessage(Map<String, dynamic> content) {
    final data = content['data'];
    if (data == null) return;
    final type = data['type'] as String?;
    switch (type) {
      case 'call_incoming':
        _handleIncomingCall(data['body']);
        break;
      case 'call_accepted':
        _handleCallAccepted(data['body']);
        break;
      case 'call_rejected':
        _handleCallRejected(data['body']);
        break;
      case 'call_ended':
        _handleCallEnded(data['body']);
        break;
      default:
        _handleCallMessage(content);
    }
  }

  void _handleIncomingCall(dynamic body) {
    if (body is Map<String, dynamic>) {
      // TODO: 处理来电
      print('[CallReceiver] 收到来电: $body');
    }
  }

  void _handleCallAccepted(dynamic body) {
    // TODO: 处理通话接受
  }

  void _handleCallRejected(dynamic body) {
    // TODO: 处理通话拒绝
  }

  void _handleCallEnded(dynamic body) {
    // TODO: 处理通话结束
  }

  void _handleCallMessage(Map<String, dynamic> content) {
    // TODO: 处理其他通话消息
    print('[CallReceiver] 收到通话消息: $content');
  }
}