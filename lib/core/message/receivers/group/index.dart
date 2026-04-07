import './group.dart';
import './group_join_request_receiver.dart';
import './group_member_receiver.dart';

/// Group message router.
class GroupMessageRouter {
  /**
   * 处理群组消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processGroupMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[GroupMessageRouter] 收到群组消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      case 'group_receive':
        await groupReceiver.handleTableUpdates(body);
        break;
      case 'group_member_receive':
        await groupMemberReceiver.handleTableUpdates(body);
        break;
      case 'group_join_request_receive':
        await groupJoinRequestReceiver.handleTableUpdates(body);
        break;
      default:
        break;
    }
  }
}

final groupMessageRouter = GroupMessageRouter();
