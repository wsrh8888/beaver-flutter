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
import 'package:beaver/api/chat.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/store/message/message.dart';
import 'package:drift/drift.dart';
import 'package:beaver/core/database/services/chat/conversation.dart';

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
    final chats = await _service.getChatHistory(
      conversationId,
      limit: limit,
      offset: offset,
    );
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
    print(
      '[MessageBusiness] WS 已发送: type=$wsType, msgType=${msg.type.name}, messageId=$messageId',
    );

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
      case MessageType.markdown:
        return msg.markdownMsg?.title?.isNotEmpty == true
            ? msg.markdownMsg!.title!
            : (msg.markdownMsg?.content ?? '[Markdown]');
      case MessageType.reply:
        return msg.replyMsg?.replyMsg?.textMsg?.content ?? '[回复]';
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

  /**
   * 处理 WebSocket 推送的新消息 (对标 PC handleWSMessage)
   */
  Future<void> handleNewWSMessage(Map<String, dynamic> data) async {
    print(
      '[MessageBusiness] handleNewWSMessage type=${data['data']?['type']} body.msgId=${data['body']?['messageId']}',
    );
    final body = data['body'] as Map<String, dynamic>?;
    final conversationId = data['conversationId'] as String?;
    if (conversationId == null || body == null) return;

    final sender = body['sender'] as Map<String, dynamic>?;
    final sendUserId = sender?['userId'] as String?;
    final msgData = body['msg'] as Map<String, dynamic>?;
    final seq = body['seq'] as int? ?? 0;
    final createdAtStr = body['createdAt']?.toString() ?? '';
    final createdAt =
        int.tryParse(createdAtStr) ??
        (DateTime.now().millisecondsSinceEpoch ~/ 1000);

    if (msgData == null) return;

    // 1. 保存到数据库
    await _service.create(
      ChatsCompanion(
        messageId: Value(body['messageId'] as String),
        conversationId: Value(conversationId),
        conversationType: Value(conversationId.startsWith('group_') ? 2 : 1),
        sendUserId: Value(sendUserId),
        msgType: Value(msgData['type'] as int? ?? 1),
        msg: Value(jsonEncode(msgData)),
        seq: Value(seq),
        sendStatus: const Value(1), // Sent
        createdAt: Value(createdAt),
        updatedAt: Value(createdAt),
      ),
    );

    // 2. 更新会话最后消息
    await getIt<ChatConversationService>().updateLastMessage(
      conversationId,
      _generateMessagePreview(MessageContentModel.fromJson(msgData)),
      maxSeq: seq,
    );

    // 3. 通知 Store 更新 UI (MessageStore 暂时维持直接调用，ChatStore 走 Stream)
    final model = MessageModel(
      id: body['messageId'] as String,
      conversationId: conversationId,
      userId: sendUserId ?? '',
      nickname: sender?['nickName']?.toString() ?? '',
      avatar: sender?['avatar']?.toString() ?? '',
      msg: MessageContentModel.fromJson(msgData),
      type: _mapIntToType(msgData['type'] as int? ?? 1),
      status: MessageStatus.sent,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt * 1000),
      isSent: sendUserId == getIt<UserStore>().state.currentUserId,
    );
    print(
      '[MessageBusiness] handleNewWSMessage: adding message ${model.id} to store (WS PUSH)',
    );
    getIt<MessageStore>().addMessage(conversationId, model);

    // 4. 发送会话流更新通知 (让 ChatStore 响应)
    getIt<ConversationBusiness>().notifyConversationUpdate();
  }

  /**
   * 按具体版本号同步消息 (对标 PC syncMessagesByVersion)
   */
  Future<void> syncMessagesByVersion(String conversationId, int version) async {
    // 简单起见，这里直接调用区间同步。PC端这里通常会进队列聚合。
    await syncMessagesByVersionRange(conversationId, version, version);
  }

  /**
   * 按版本区间同步消息 (对标 PC syncMessagesByVersionRange)
   */
  Future<void> syncMessagesByVersionRange(
    String conversationId,
    int minVersion,
    int maxVersion,
  ) async {
    print(
      '[MessageBusiness] 开始拉取消息: conv=$conversationId, range=[$minVersion, $maxVersion]',
    );
    try {
      final response = await chatSyncApi(
        IChatSyncReq(
          conversationId: conversationId,
          fromSeq: minVersion,
          toSeq: maxVersion,
          limit: 100,
        ),
      );

      if (response.code == 0 && response.result != null) {
        final messages = response.result!.messages;
        print('[MessageBusiness] 拉取成功: count=${messages.length}');
        if (messages.isNotEmpty) {
          await _handleSyncedMessages(messages);
          print(
            '[MessageBusiness] 同步消息落库完成: conv=$conversationId, range=[$minVersion, $maxVersion]',
          );
        }
      } else {
        print(
          '[MessageBusiness] 拉取失败: code=${response.code}, msg=${response.msg}',
        );
      }
    } catch (e) {
      print('[MessageBusiness] 同步消息异常: $e');
    }
  }

  /// 将批量同步到的消息落库并刷新 Store / 会话列表
  Future<void> applySyncedMessages(List<IChatMessageItem> messages) async {
    await _handleSyncedMessages(messages);
  }

  /**
   * 处理同步到的消息并落库 (对标 PC handleSyncedMessages)
   */
  Future<void> _handleSyncedMessages(List<IChatMessageItem> messages) async {
    if (messages.isEmpty) return;

    print('[MessageBusiness] 正在处理落库消息: count=${messages.length}');

    final companions = messages.map((msg) {
      return ChatsCompanion(
        messageId: Value(msg.messageId),
        conversationId: Value(msg.conversationId),
        conversationType: Value(msg.conversationType),
        sendUserId: Value(msg.sendUserId),
        msgType: Value(msg.msgType),
        msgPreview: Value(msg.msgPreview),
        msg: Value(msg.msg),
        seq: Value(msg.seq),
        sendStatus: const Value(1), // 1: 已发送 (服务端同步回来的必然是已发送)
        createdAt: Value(msg.createdAt),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      );
    }).toList();

    // 批量保存到数据库 (使用 upsert 逻辑由 service 层保证)
    await _service.batchCreate(companions);

    // 同步到 Store 更新 UI
    final messageStore = getIt<MessageStore>();
    final Map<String, IChatMessageItem> latestMessages = {};

    for (final msg in messages) {
      // 跟踪每个会话的最新的消息，用于更新会话列表预览
      final existingLatest = latestMessages[msg.conversationId];
      if (existingLatest == null || msg.seq > existingLatest.seq) {
        latestMessages[msg.conversationId] = msg;
      }

      // 简单映射为 UI 模型
      final model = MessageModel(
        id: msg.messageId,
        conversationId: msg.conversationId,
        userId: msg.sendUserId,
        msg: MessageContentModel.fromJson(jsonDecode(msg.msg)),
        type: _mapIntToType(msg.msgType),
        status: MessageStatus.sent,
        createdAt: DateTime.fromMillisecondsSinceEpoch(msg.createdAt * 1000),
        isSent: msg.sendUserId == getIt<UserStore>().state.currentUserId,
      );
      print(
        '[MessageBusiness] _handleSyncedMessages: adding message ${model.id} to store (SYNC PULL)',
      );
      messageStore.addMessage(msg.conversationId, model);
    }

    // 更新各会话的最后一条消息预览和 Seq
    final conversationService = getIt<ChatConversationService>();
    for (final entry in latestMessages.entries) {
      final convId = entry.key;
      final latestMsg = entry.value;

      try {
        await conversationService.updateLastMessage(
          convId,
          latestMsg.msgPreview,
          maxSeq: latestMsg.seq,
        );
      } catch (e) {
        print('[MessageBusiness] 更新会话最后消息失败: $e');
      }
    }

    // 触发 ChatStore 刷新，更新会话列表的未读数和最后一条消息
    getIt<ConversationBusiness>().notifyConversationUpdate();
  }

  MessageType _mapIntToType(int type) {
    switch (type) {
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      case 3:
        return MessageType.video;
      case 4:
        return MessageType.file;
      case 5:
        return MessageType.voice;
      case 6:
        return MessageType.emoji;
      case 7:
        return MessageType.notification;
      case 8:
        return MessageType.audio;
      case 9:
        return MessageType.call;
      case 10:
        return MessageType.recalled;
      case 11:
        return MessageType.reply;
      case 12:
        return MessageType.mergedForward;
      case 13:
        return MessageType.markdown;
      default:
        return MessageType.text;
    }
  }

  int _mapTypeToInt(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 1;
      case MessageType.image:
        return 2;
      case MessageType.video:
        return 3;
      case MessageType.file:
        return 4;
      case MessageType.voice:
        return 5;
      case MessageType.emoji:
        return 6;
      case MessageType.notification:
        return 7;
      case MessageType.audio:
        return 8;
      case MessageType.call:
        return 9;
      case MessageType.recalled:
        return 10;
      case MessageType.reply:
        return 11;
      case MessageType.mergedForward:
        return 12;
      case MessageType.markdown:
        return 13;
      default:
        return 1;
    }
  }

  /// 编辑文本/Markdown 消息
  Future<String?> editMessage(
    String messageId,
    String conversationId,
    String content,
  ) async {
    if (content.trim().isEmpty) {
      return '消息内容不能为空';
    }

    final chat = await _service.getById(messageId);
    if (chat == null) {
      return '消息不存在';
    }

    final createdAt = chat.createdAt ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch ~/ 1000 - createdAt;
    if (elapsed > 24 * 3600) {
      return '超过24小时，无法编辑';
    }

    if (chat.msgType != 1 && chat.msgType != 13) {
      return '仅支持编辑文本或 Markdown 消息';
    }

    final res = await editMessageApi(
      IEditMessageReq(messageId: messageId, content: content),
    );
    if (res.code != 0) {
      return res.msg;
    }

    final Map<String, dynamic> msgJson =
        jsonDecode(chat.msg ?? '{}') as Map<String, dynamic>;
    if (chat.msgType == 1) {
      msgJson['textMsg'] = {'content': content};
    } else {
      final markdown = msgJson['markdownMsg'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(msgJson['markdownMsg'] as Map)
          : <String, dynamic>{};
      markdown['content'] = content;
      msgJson['markdownMsg'] = markdown;
    }

    final newMsg = MessageContentModel.fromJson(msgJson);
    final preview = _generateMessagePreview(newMsg);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _service.upsert(
      ChatsCompanion(
        messageId: Value(messageId),
        msg: Value(jsonEncode(msgJson)),
        msgPreview: Value(preview),
        updatedAt: Value(now),
      ),
    );

    getIt<MessageStore>().updateMessageContent(
      conversationId,
      messageId,
      newMsg,
    );
    return null;
  }

  /// 撤回消息（成功后由 WS 推送 Withdraw 指令更新 UI）
  Future<String?> recallMessage(String messageId, String conversationId) async {
    final chat = await _service.getById(messageId);
    if (chat == null) {
      return '消息不存在';
    }

    final createdAt = chat.createdAt ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch ~/ 1000 - createdAt;
    if (elapsed > 3 * 60) {
      return '超过3分钟，无法撤回';
    }

    final res = await recallMessageApi(IRecallMessageReq(messageId: messageId));
    if (res.code != 0) {
      return res.msg;
    }
    return null;
  }

  /// 删除消息（仅对自己生效）
  Future<String?> deleteMessage(String messageId, String conversationId) async {
    final res = await deleteMessagesApi(
      IDeleteMessagesReq(messageIds: [messageId]),
    );
    if (res.code != 0) {
      return res.msg;
    }

    await _service.batchDelete([messageId]);
    getIt<MessageStore>().removeMessages(conversationId, [messageId]);
    return null;
  }

  @override
  Future<void> clearHistory(String conversationId) async {
    // 1. 清空本地数据库中的消息
    await _service.clearHistory(conversationId);

    // 2. 清空会话元数据中的最后一条消息，并更新时间戳
    final conversationService = getIt<ChatConversationService>();
    await conversationService.upsert(
      ChatConversationsCompanion(
        conversationId: Value(conversationId),
        lastMessage: const Value(''),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
    );

    // 3. 通知全局会话列表刷新
    getIt<ConversationBusiness>().notifyConversationUpdate();
  }
}
