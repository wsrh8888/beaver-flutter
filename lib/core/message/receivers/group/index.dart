import './group.dart';
import './group_join_request_receiver.dart';
import './group_member_receiver.dart';

/// Group message router.
class GroupMessageRouter {
  Future<void> processGroupMessage(Map<String, dynamic> data) async {
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
