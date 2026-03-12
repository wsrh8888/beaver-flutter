import 'package:beaver/core/sync/sync_manager.dart';

/// 聊天 WS 消息接收器 (对标 desktop message-manager/receivers/chat)
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
      SyncManager.instance.onIncomingWsMessage(body);
    }
  }

  void _handleConversationMeta(dynamic body) {}
  void _handleUserConversation(dynamic body) {}
}
