import './friend_verify_receiver.dart';
import './receiver.dart';

/**
 * 好友消息路由器
 * 对标 PC receivers/friend/index.ts
 */
class FriendMessageRouter {
  final _friendReceiver = friendReceiver;
  final _friendVerifyReceiver = friendVerifyReceiver;

  /**
   * 处理好友消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processFriendMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[FriendMessageRouter] 收到好友消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      // 好友信息同步
      case 'friend_receive':
        await _friendReceiver.handleTableUpdates(body);
        break;

      // 好友验证信息同步
      case 'friend_verify_receive':
        await _friendVerifyReceiver.handleTableUpdates(body);
        break;

      default:
        print('[FriendMessageRouter] 未处理的好友消息类型: $type');
    }
  }
}

final friendMessageRouter = FriendMessageRouter();
