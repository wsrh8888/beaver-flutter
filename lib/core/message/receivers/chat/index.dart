import './message_receiver.dart';
import './conversation_receiver.dart';
import './user_conversation_receiver.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';

/// 聊天消息路由器 (对标 PC receivers/chat/index.ts)
/// 根据消息类型路由到对应的接收器
class ChatMessageRouter {
  final _messageReceiver = messageReceiver;
  final _conversationReceiver = conversationReceiver;
  final _userConversationReceiver = userConversationReceiver;

  /**
   * 处理聊天消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processChatMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[ChatMessageRouter] 收到路由消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;
    final conversationId = data['conversationId'] as String?;

    print(
      '[ChatMessageRouter] 收到路由消息: type=$type, convId=$conversationId, hasBody=${body != null}',
    );

    if (type == null || body == null) return;

    switch (type) {
      // 聚合消息更新 - 包含所有表的更新
      case 'chat_conversation_message_receive':
        print('[ChatMessageRouter] 命中聚合消息同步: $type, convId=$conversationId');
        await _messageReceiver.handleTableUpdates(body);
        break;

      // 会话相关的更新
      case 'chat_conversation_meta_receive':
        await _conversationReceiver.handleTableUpdates(body);
        break;

      // 用户会话相关的更新
      case 'chat_user_conversation_receive':
        await _userConversationReceiver.handleTableUpdates(body);
        break;

      // 处理常规消息接收 (私聊/群聊新消息)
      case 'private_message_receive':
      case 'group_message_receive':
      case 'private_message_sync':
      case 'group_message_sync':
        await getIt<MessageBusiness>().handleNewWSMessage(data);
        if (type.contains('sync')) {
          final messageId = body['messageId'] as String?;
          if (messageId != null) {
            getIt<MessageBusiness>().clearTimers([messageId]);
          }
        }
        break;

      // 处理发送成功 ACK
      case 'private_message_send_ack':
      case 'group_message_send_ack':
        final messageId = body['messageId'] as String?;
        if (messageId != null) {
          getIt<MessageBusiness>().clearTimers([messageId]);
        }
        break;

      default:
        print('[ChatMessageRouter] 未处理的消息类型: $type');
    }
  }
}

final chatMessageRouter = ChatMessageRouter();
