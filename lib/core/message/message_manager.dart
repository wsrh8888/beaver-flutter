import 'package:beaver/core/datasync/sync_manager.dart';
import 'package:beaver/core/datasync/sync_manager.dart' show syncManager;

import 'receivers/call/receiver.dart';
import 'receivers/chat/message_receiver.dart';
import 'receivers/friend/receiver.dart';
import 'receivers/group/receiver.dart';
import 'receivers/notification/receiver.dart';
import 'receivers/user/receiver.dart';

/// 消息管理器
/// 
/// 职责：业务层消息管理，协调数据同步和消息分发
/// - 管理数据同步状态
/// - 消息队列管理
/// - 消息分发到各业务接收器
class MessageManager {
  bool _isDataSyncing = false;
  final List<Map<String, dynamic>> _messageQueue = [];

  final ChatMessageReceiver _chatReceiver = ChatMessageReceiver();
  final FriendMessageReceiver _friendReceiver = FriendMessageReceiver();
  final GroupMessageReceiver _groupReceiver = GroupMessageReceiver();
  final NotificationMessageReceiver _notificationReceiver = NotificationMessageReceiver();
  final UserMessageReceiver _userReceiver = UserMessageReceiver();
  final CallMessageReceiver _callReceiver = CallMessageReceiver();

  Future<void> onWsConnect() async {
    print('[MessageManager] WS 连接成功，开始数据同步');
    try {
      _isDataSyncing = true;
      await syncManager.autoSync();
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
      case 'SYSTEM_MESSAGE':
        // TODO: 处理系统消息
        break;
      case 'CALL_OPERATION':
        _callReceiver.processCallMessage(map);
        break;
      case 'HEARTBEAT':
        break;
      default:
        print('[MessageManager] 未处理 command: $command');
    }
  }
}

final messageManager = MessageManager();