import './group.dart';
import './group_member_receiver.dart';
import './group_join_request_receiver.dart';

/// 群组消息路由器 (对标 PC receivers/group/index.ts)
class GroupMessageRouter {
  void processGroupMessage(Map<String, dynamic> data) {
    print('[GroupMessageRouter] 收到群组指令消息: $data');

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      // 群组信息同步
      case 'group_receive':
        groupReceiver.handleTableUpdates(body);
        break;

      // 群成员变动
      case 'group_member_receive':
        groupMemberReceiver.handleTableUpdates(body);
        break;

      // 群加入请求
      case 'group_join_request_receive':
        groupJoinRequestReceiver.handleTableUpdates(body);
        break;
      
      default:
        print('[GroupMessageRouter] 未处理的群组消息类型: $type');
    }
  }
}

final groupMessageRouter = GroupMessageRouter();