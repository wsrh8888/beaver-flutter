import 'dart:convert';
import 'dart:async';
import 'package:beaver/core/database/services/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:drift/drift.dart';

/// 聊天消息业务逻辑
class MessageBusiness implements MessageRepositoryInterface {
  final ChatMessageService _service = getIt<ChatMessageService>();
  final WsConnectionManager _wsManager = getIt<WsConnectionManager>();

  final Map<String, Timer> _sendingTimers = {};

  @override
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    // limit + 1 用于判断是否还有更多
    final chats = await _service.getChatHistory(conversationId, limit: limit);
    final currentUserId = getIt<UserStore>().state.currentUserId;

    return chats.map((chat) {
      MessageContentModel msg;
      try {
        final Map<String, dynamic> msgJson = jsonDecode(chat.msg ?? '{}');
        msg = MessageContentModel.fromJson(msgJson);
      } catch (e) {
        msg = MessageContentModel(
          type: MessageType.text,
          textMsg: TextMsg(content: chat.msg ?? ''),
        );
      }

      return MessageModel(
        id: chat.messageId,
        userId: chat.sendUserId ?? '',
        msg: msg,
        type: msg.type,
        status: _mapIntToStatus(chat.sendStatus),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (chat.createdAt ?? 0) * 1000,
        ),
        isSent: chat.sendUserId == currentUserId,
        conversationId: conversationId,
      );
    }).toList();
  }

  @override
  Future<MessageModel> sendMessage(ChatMessageSendBody data) async {
    final now = DateTime.now();
    final userStore = getIt<UserStore>();
    final contactStore = getIt<ContactStore>();
    final userId = userStore.state.currentUserId;

    final conversationId = data.conversationId;
    final messageId = data.messageId;
    final msg = data.msg;
    final chatType = data.chatType;

    // 获取发送者信息
    final senderInfo = userStore.getUserInfo(contactStore);
    final senderNickname = senderInfo?.nickname ?? '';
    final senderAvatar = senderInfo?.avatar ?? '';

    final isGroup = chatType == 'group';
    final convType = isGroup ? 2 : 1;
    final wsType = isGroup ? 'group_message_send' : 'private_message_send';
    final preview = _generateMessagePreview(msg);

    // 1. 本地落库 (发送中状态)
    await _service.create(
      ChatsCompanion(
        messageId: Value(messageId),
        conversationId: Value(conversationId),
        conversationType: Value(convType),
        sendUserId: Value(userId),
        msgType: Value(_mapTypeToInt(msg.type)),
        msgPreview: Value(preview),
        msg: Value(jsonEncode(msg.toJson())),
        sendStatus: const Value(0), // 0: 发送中
        createdAt: Value(now.millisecondsSinceEpoch ~/ 1000),
        updatedAt: Value(now.millisecondsSinceEpoch ~/ 1000),
      ),
    );

    // 2. 通过 WS 发送 (对标 Desktop WsContent 结构)
    _wsManager.send({
      'command': 'CHAT_MESSAGE',
      'content': {
        'timestamp': now.millisecondsSinceEpoch,
        'messageId': messageId,
        'data': {
          'type': wsType,
          'conversationId': conversationId,
          'body': data.toJson(),
        },
      },
    });

    // 3. 开启超时处理
    _sendingTimers[messageId] = Timer(const Duration(seconds: 10), () {
      _handleTimeout(messageId);
    });

    return MessageModel(
      id: messageId,
      conversationId: conversationId,
      userId: userId,
      nickname: senderNickname,
      avatar: senderAvatar,
      msg: msg,
      type: msg.type,
      status: MessageStatus.sending,
      createdAt: now,
      isSent: true,
    );
  }

  String _generateMessagePreview(MessageContentModel msg) {
    switch (msg.type) {
      case MessageType.text:
        return msg.textMsg?.content ?? '[文本消息]';
      case MessageType.image:
        return '[图片]';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        return '[文件]';
      case MessageType.voice:
        return '[语音]';
      default:
        return '[消息]';
    }
  }

  @override
  Future<void> updateMessageStatus(
    String messageId,
    MessageStatus status,
  ) async {
    await _service.batchUpdateSendStatus([messageId], _mapStatusToInt(status));
  }

  @override
  Future<ChatModel?> getConversation(String conversationId) async {
    return getIt<ConversationBusiness>().getConversation(conversationId);
  }

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) {
    // TODO: 实现 Drift 的 Stream 监听
    return Stream.value([]);
  }

  void clearTimers(List<String> messageIds) {
    for (var messageId in messageIds) {
      _sendingTimers[messageId]?.cancel();
      _sendingTimers.remove(messageId);
    }

    // 更新数据库状态 (由外部同步逻辑决定状态，通常是 1:已发送)
    _service.batchUpdateSendStatus(messageIds, 1);
  }

  void _handleTimeout(String messageId) async {
    _sendingTimers.remove(messageId);
    final msg = await _service.getById(messageId);
    if (msg != null && msg.sendStatus == 0) {
      await _service.batchUpdateSendStatus([messageId], 2); // 2: 失败
    }
  }

  MessageStatus _mapIntToStatus(int status) {
    switch (status) {
      case 0:
        return MessageStatus.sending;
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  int _mapStatusToInt(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 0;
      case MessageStatus.sent:
        return 1;
      case MessageStatus.failed:
        return 2;
      default:
        return 1;
    }
  }

  int _mapTypeToInt(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 1;
      case MessageType.image:
        return 2;
      // ... 其他类型映射
      default:
        return 1;
    }
  }
}
