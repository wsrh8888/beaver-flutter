import 'package:beaver/core/business/chat/user_conversation.dart';
import 'package:beaver/di/injection.dart';

/// 用户会话接收器 - 处理 user_conversations 表的操作
class UserConversationReceiver {
  UserConversationBusiness get _userConversationBusiness => getIt<UserConversationBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates = (tableUpdatesBody['tableUpdates'] ?? tableUpdatesBody['tables']) as List?;
    if (tableUpdates == null) return;

    for (final update in tableUpdates) {
      final table = update['table'] as String?;
      final conversationId = update['conversationId'] as String?;
      final userId = update['userId']?.toString();
      final data = update['data'] as List?;

      if (table == 'user_conversations' &&
          conversationId != null &&
          userId != null &&
          data != null) {
        for (final item in data) {
          final version = item['version'] as int?;
          if (version != null) {
            await _userConversationBusiness.handleTableUpdates(
              userId,
              conversationId,
              version,
            );
          }
        }
      }
    }
  }
}

final userConversationReceiver = UserConversationReceiver();
