import './user.dart';

/// User message router.
class UserMessageRouter {
  final _userReceiver = userReceiver;

  /**
   * 处理用户消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processUserMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      print('[UserMessageRouter] 收到用户消息, 但缺少 data 字段: $wsMessage');
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      case 'user_receive':
        await _userReceiver.handleTableUpdates(body);
        break;
      default:
        break;
    }
  }
}

final userMessageRouter = UserMessageRouter();
