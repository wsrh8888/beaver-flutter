import './user.dart';

/// 用户消息路由器 (对标 PC receivers/user/index.ts)
class UserMessageRouter {
  final _userReceiver = userReceiver;

  /**
   * 处理用户消息
   * @param wsMessage WebSocket 消息内容
   */
  void processUserMessage(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      // 用户资料同步
      case 'user_receive':
        _userReceiver.handleTableUpdates(body);
        break;

      default:
        print('[UserMessageRouter] 未知的工作类型: $type');
    }
  }
}

final userMessageRouter = UserMessageRouter();
