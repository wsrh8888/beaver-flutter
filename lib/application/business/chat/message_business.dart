import 'dart:async';

import 'package:beaver/core/database/database.dart';
import 'package:beaver/core/network/websocket/websocket.dart';
import 'package:beaver/di/injection.dart';

import '../base/base.dart';

/// 消息同步队列项 (对标 desktop MessageSyncItem)
class MessageSyncItem extends QueueItem {
  @override
  final String key;
  @override
  final dynamic data;
  @override
  final int timestamp;
  final String conversationId;
  final int minVersion;
  final int maxVersion;

  MessageSyncItem({
    required this.conversationId,
    required this.minVersion,
    required this.maxVersion,
    required this.key,
    required this.data,
    required this.timestamp,
  });
}

/// 消息业务：发消息、拉历史、同步落库、超时/ACK (对标 desktop business/chat/message.ts)
class MessageBusiness extends BaseBusiness<MessageSyncItem> {
  MessageBusiness()
      : super(BusinessBatchConfig(queueSizeLimit: 20, delayMs: 1000));

  @override
  String get businessName => 'MessageBusiness';

  final Map<String, Timer> _sendingTimers = {};

  Future<void> sendMessage({
    required String userId,
    required String conversationId,
    required String messageId,
    required Map<String, dynamic> msg,
    required int chatType,
  }) async {
    final messageService = getIt<MessageService>();
    await messageService.insert(
      ChatsCompanion.insert(
        messageId: messageId,
        conversationId: conversationId,
        conversationType: Value(chatType),
        sendUserId: Value(userId),
        msgType: Value(msg['type'] as int? ?? 1),
        msgPreview: Value(msg['preview'] as String?),
        msg: Value(msg.toString()),
        sendStatus: const Value(0),
        seq: const Value(0),
      ),
    );
    getIt<WsConnectionManager>().send({
      'command': 'CHAT_MESSAGE',
      'content': {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'messageId': messageId,
        'data': {
          'type': chatType == 1 ? 'PRIVATE_MESSAGE_SEND' : 'GROUP_MESSAGE_SEND',
          'conversationId': conversationId,
          'body': {'conversationId': conversationId, 'messageId': messageId, 'msg': msg, 'chatType': chatType},
        },
      },
    });
    _sendingTimers[messageId] = Timer(const Duration(seconds: 10), () {
      _handleMessageTimeout(messageId, conversationId);
    });
  }

  void clearTimers(List<String> messageIds) {
    for (final id in messageIds) {
      _sendingTimers[id]?.cancel();
      _sendingTimers.remove(id);
    }
  }

  Future<void> _handleMessageTimeout(String messageId, String conversationId) async {
    _sendingTimers.remove(messageId);
    final messageService = getIt<MessageService>();
    final current = await messageService.getByMessageId(messageId);
    if (current == null || current.sendStatus != 0) return;
    await messageService.insertOrUpdate(
      ChatsCompanion(
        id: Value(current.id),
        messageId: Value(messageId),
        conversationId: Value(conversationId),
        conversationType: Value(current.conversationType),
        sendUserId: Value(current.sendUserId),
        msgType: Value(current.msgType),
        msgPreview: Value(current.msgPreview),
        msg: Value(current.msg),
        sendStatus: const Value(2),
        seq: Value(current.seq),
      ),
    );
  }

  Future<Map<String, dynamic>> getChatHistory({
    required String conversationId,
    int? beforeSeq,
    int limit = 20,
  }) async {
    final messageService = getIt<MessageService>();
    final userService = getIt<UserService>();
    final list = await messageService.getHistory(conversationId, beforeSeq: beforeSeq, limit: limit);
    final senderIds = list.map((m) => m.sendUserId).whereType<String>().toSet().toList();
    final users = senderIds.isEmpty ? <User>[] : await userService.getByUserIds(senderIds);
    final userMap = {for (var u in users) u.userId: u};
    final formatted = list.map((m) {
      final u = userMap[m.sendUserId];
      return {
        'messageId': m.messageId,
        'conversationId': m.conversationId,
        'seq': m.seq,
        'msg': m.msg,
        'sender': {'userId': m.sendUserId, 'nickName': u?.nickName, 'avatar': u?.avatar},
        'sendStatus': m.sendStatus,
      };
    }).toList();
    return {'count': formatted.length, 'list': formatted};
  }

  Future<void> syncMessagesByVersionRange(
    String conversationId,
    int minVersion,
    int maxVersion,
  ) async {
    addToQueue(MessageSyncItem(
      key: conversationId,
      data: {'conversationId': conversationId, 'minVersion': minVersion, 'maxVersion': maxVersion},
      timestamp: DateTime.now().millisecondsSinceEpoch,
      conversationId: conversationId,
      minVersion: minVersion,
      maxVersion: maxVersion,
    ));
  }

  @override
  Future<void> processBatchRequests(List<MessageSyncItem> items) async {
    for (final item in items) {
      await Future.delayed(Duration.zero);
    }
  }
}
