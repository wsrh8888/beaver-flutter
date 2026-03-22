import 'dart:convert';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/chat/message.dart';
import 'package:beaver/core/database/services/chat/conversation.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/message/message.dart';
import 'package:beaver/types/business/message.dart';
import 'package:drift/drift.dart';

/// 聊天消息接收器
class ChatMessageReceiver {
  ChatMessageService get _messageService => getIt<ChatMessageService>();
  ChatConversationService get _conversationService =>
      getIt<ChatConversationService>();
  MessageStore get _messageStore => getIt<MessageStore>();
  MessageBusiness get _messageBusiness => getIt<MessageBusiness>();

  void processChatMessage(Map<String, dynamic> data) async {
    print('[ChatMessageReceiver] 处理聊天消息: $data');

    final type = data['type'] as String?;
    final conversationId = data['conversationId'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (conversationId == null || body == null) return;

    // 1. 处理私聊/群聊消息接收
    if (type == 'private_message_receive' ||
        type == 'group_message_receive' ||
        type == 'private_message_sync' ||
        type == 'group_message_sync') {
      final messageId = body['messageId'] as String?;
      final sender = body['sender'] as Map<String, dynamic>?;
      final sendUserId = sender?['userId'] as String?;
      final msgData = body['msg'] as Map<String, dynamic>?;
      final seq = body['seq'] as int? ?? 0;
      final createdAtStr = body['createdAt']?.toString() ?? '';
      final createdAt =
          int.tryParse(createdAtStr) ??
          (DateTime.now().millisecondsSinceEpoch ~/ 1000);

      if (type == null || messageId == null || msgData == null) return;

      final isGroup = type.contains('group');
      final convType = isGroup ? 2 : 1;

      // 保存到数据库
      await _messageService.create(
        ChatsCompanion(
          messageId: Value(messageId),
          conversationId: Value(conversationId),
          conversationType: Value(convType),
          sendUserId: Value(sendUserId),
          msgType: Value(msgData['type'] as int? ?? 1),
          msg: Value(jsonEncode(msgData)),
          seq: Value(seq),
          sendStatus: const Value(1), // Sent
          createdAt: Value(createdAt),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        ),
      );

      // 更新会话最后消息
      await _conversationService.updateLastMessage(
        conversationId,
        _generatePreview(msgData),
        maxSeq: seq,
      );

      // 通知 Store 更新 UI
      final model = MessageModel(
        id: messageId,
        conversationId: conversationId,
        userId: sendUserId ?? '',
        nickname: sender?['nickName']?.toString() ?? '',
        avatar: sender?['avatar']?.toString() ?? '',
        msg: MessageContentModel.fromJson(msgData),
        type: _mapIntToType(msgData['type'] as int? ?? 1),
        status: MessageStatus.sent,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt * 1000),
        isSent: sendUserId == DatabaseManager.currentUserId,
      );
      _messageStore.addMessage(conversationId, model);

      // 如果是我们自己发的同步消息，也要清除定时器
      if (type.contains('sync')) {
        _messageBusiness.clearTimers([messageId]);
      }
    }

    // 2. 处理 ACK (假设类型名为 private_message_send_ack 或由服务器定义)
    // 如果服务器直接返回 ACK type，这里需要根据实际调整
    if (type == 'private_message_send_ack' ||
        type == 'group_message_send_ack') {
      final messageId = body['messageId'] as String?;
      if (messageId != null) {
        _messageBusiness.clearTimers([messageId]);
      }
    }
  }

  String _generatePreview(Map<String, dynamic> msgData) {
    final type = msgData['type'] as int? ?? 1;
    switch (type) {
      case 1:
        return msgData['textMsg']?['content']?.toString() ?? '[文本]';
      case 2:
        return '[图片]';
      case 6:
        return '[表情]';
      default:
        return '[消息]';
    }
  }

  MessageType _mapIntToType(int type) {
    switch (type) {
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      case 6:
        return MessageType.emoji;
      default:
        return MessageType.text;
    }
  }
}

final chatMessageReceiver = ChatMessageReceiver();
