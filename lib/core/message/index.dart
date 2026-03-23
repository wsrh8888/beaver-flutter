import 'package:beaver/core/datasync/manager.dart' show syncManager;
import 'package:beaver/core/message/receivers/call/call.dart';
import 'package:beaver/core/message/receivers/chat/index.dart';
import 'package:beaver/core/message/receivers/friend/index.dart';
import 'package:beaver/core/message/receivers/group/index.dart';
import 'package:beaver/core/message/receivers/notification/index.dart';
import 'package:beaver/core/message/receivers/user/index.dart';

/// Message manager: ensures sync-first and ordered message dispatch.
class MessageManager {
  bool _isDataSyncing = false;
  final List<Map<String, dynamic>> _messageQueue = [];
  bool _isQueueDraining = false;

  final ChatMessageRouter _chatRouter = chatMessageRouter;
  final FriendMessageRouter _friendRouter = friendMessageRouter;
  final GroupMessageRouter _groupRouter = groupMessageRouter;
  final NotificationMessageRouter _notificationRouter = notificationMessageRouter;
  final UserMessageRouter _userRouter = userMessageRouter;
  final CallMessageReceiver _callReceiver = CallMessageReceiver();

  Future<void> onWsConnect() async {
    try {
      _isDataSyncing = true;
      await syncManager.autoSync();
    } finally {
      _isDataSyncing = false;
      _startDrainQueue();
    }
  }

  void onWsConnecting() {}
  void onWsDisconnect() {}
  void onWsError(dynamic error) {}

  void handleMessage(Map<String, dynamic> data) {
    _messageQueue.add(data);
    if (_isDataSyncing) return;
    _startDrainQueue();
  }

  void _startDrainQueue() {
    if (_isQueueDraining) return;
    _isQueueDraining = true;
    _drainQueue();
  }

  Future<void> _drainQueue() async {
    try {
      while (!_isDataSyncing && _messageQueue.isNotEmpty) {
        final message = _messageQueue.removeAt(0);
        try {
          await _processMessage(message);
        } catch (_) {}
      }
    } finally {
      _isQueueDraining = false;
      if (!_isDataSyncing && _messageQueue.isNotEmpty) {
        _startDrainQueue();
      }
    }
  }

  Future<void> _processMessage(Map<String, dynamic> wsMessage) async {
    final command = wsMessage['command'] as String?;
    final content = wsMessage['content'];
    final map = content is Map
        ? Map<String, dynamic>.from(content)
        : <String, dynamic>{};

    switch (command) {
      case 'CHAT_MESSAGE':
        await _chatRouter.processChatMessage(map);
        break;
      case 'FRIEND_OPERATION':
        await _friendRouter.processFriendMessage(map);
        break;
      case 'GROUP_OPERATION':
        await _groupRouter.processGroupMessage(map);
        break;
      case 'NOTIFICATION':
        await _notificationRouter.processNotificationMessage(map);
        break;
      case 'USER_PROFILE':
        await _userRouter.processUserMessage(map);
        break;
      case 'CALL_OPERATION':
        _callReceiver.processCallMessage(map);
        break;
      case 'SYSTEM_MESSAGE':
      case 'HEARTBEAT':
      default:
        break;
    }
  }
}
