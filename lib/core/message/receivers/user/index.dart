import './user.dart';

/// User message router.
class UserMessageRouter {
  final _userReceiver = userReceiver;

  Future<void> processUserMessage(Map<String, dynamic> data) async {
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
