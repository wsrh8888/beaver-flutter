import 'package:beaver/application/datasync/datasync.dart';

import 'receivers/chat_receiver.dart';
import 'receivers/friend_receiver.dart';
import 'receivers/group_receiver.dart';
import 'receivers/notification_receiver.dart';
import 'receivers/user_receiver.dart';

/// WS 消息管理器 (对标 desktop main/message-manager)
class MessageManager {
  bool _isDataSyncing = false;
  final List<Map<String, dynamic>> _messageQueue = [];

  final ChatMessageReceiver _chatReceiver = ChatMessageReceiver();
  final FriendMessageReceiver _friendReceiver = FriendMessageReceiver();
  final GroupMessageReceiver _groupReceiver = GroupMessageReceiver();
  final NotificationMessageReceiver _notificationReceiver = NotificationMessageReceiver();
  final UserMessageReceiver _userReceiver = UserMessageReceiver();

  Future<void> onWsConnect() async {
    print('[MessageManager] WS 连接成功，开始数据同步');
    try {
      _isDataSyncing = true;
      await dataSyncManager.autoSync();
      _isDataSyncing = false;
      _processMessageQueue();
      print('[MessageManager] 同步完成，已就绪');
    } catch (e) {
      _isDataSyncing = false;
      print('[MessageManager] 数据同步失败: $e');
    }
  }

  void onWsConnecting() => print('[MessageManager] WS 开始连接');
  void onWsDisconnect() => print('[MessageManager] WS 断开，将重连');
  void onWsError(dynamic error) => print('[MessageManager] WS 错误: $error');

  void handleMessage(Map<String, dynamic> data) {
    if (_isDataSyncing) {
      _messageQueue.add(data);
      return;
    }
    _processMessage(data);
  }

  void _processMessageQueue() {
    if (_messageQueue.isEmpty) return;
    print('[MessageManager] 处理队列消息 ${_messageQueue.length} 条');
    while (_messageQueue.isNotEmpty) {
      try {
        _processMessage(_messageQueue.removeAt(0));
      } catch (e) {
        print('[MessageManager] 处理队列消息失败: $e');
      }
    }
  }

  void _processMessage(Map<String, dynamic> wsMessage) {
    final command = wsMessage['command'] as String?;
    final content = wsMessage['content'];
    final map = content is Map ? Map<String, dynamic>.from(content) : <String, dynamic>{};
    switch (command) {
      case 'CHAT_MESSAGE':
        _chatReceiver.processChatMessage(map);
        break;
      case 'FRIEND_OPERATION':
        _friendReceiver.processFriendMessage(map);
        break;
      case 'GROUP_OPERATION':
        _groupReceiver.processGroupMessage(map);
        break;
      case 'NOTIFICATION':
        _notificationReceiver.processNotificationMessage(map);
        break;
      case 'USER_PROFILE':
        _userReceiver.processUserMessage(map);
        break;
      case 'HEARTBEAT':
        break;
      default:
        print('[MessageManager] 未处理 command: $command');
    }
  }
}
