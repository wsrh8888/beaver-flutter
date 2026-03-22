import './event_receiver.dart';
import './inbox_receiver.dart';
import './read_cursor_receiver.dart';

/// 通知消息路由器 (对标 PC receivers/notification/index.ts)
class NotificationMessageRouter {
  final _eventReceiver = eventReceiver;
  final _inboxReceiver = inboxReceiver;
  final _readCursorReceiver = readCursorReceiver;

  /**
   * 处理通知消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processNotificationMessage(Map<String, dynamic> data) async {
    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      // 通知推送消息
      case 'notification_receive':
        await _inboxReceiver.handleTableUpdates(body);
        await _readCursorReceiver.handleTableUpdates(body);
        await _eventReceiver.handleTableUpdates(body);
        break;

      // 标记已读同步消息
      case 'notification_mark_read_receive':
        await _readCursorReceiver.handleTableUpdates(body);
        break;

      default:
        print('[NotificationMessageRouter] 未知的通知消息类型: $type');
    }
  }
}

final notificationMessageRouter = NotificationMessageRouter();
