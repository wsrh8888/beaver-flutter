/// 聊天消息接收器
/// 
/// 职责：处理聊天消息相关的 WebSocket 消息
class ChatMessageReceiver {
  void processChatMessage(Map<String, dynamic> content) {
    final data = content['data'];
    if (data == null) return;
    final type = data['type'] as String?;
    switch (type) {
      case 'chat_conversation_message_receive':
        _handleMessage(data['body']);
        break;
      case 'chat_conversation_meta_receive':
        _handleConversationMeta(data['body']);
        break;
      case 'chat_user_conversation_receive':
        _handleUserConversation(data['body']);
        break;
      default:
        _handleMessage(content);
    }
  }

  void _handleMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      // TODO: 处理消息
      print('[ChatReceiver] 收到消息: $body');
    }
  }

  void _handleConversationMeta(dynamic body) {
    // TODO: 处理会话元数据
  }

  void _handleUserConversation(dynamic body) {
    // TODO: 处理用户会话
  }
}