import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';

/// 会话接收器 - 处理 conversations 表的操作
class ConversationReceiver {
  ConversationBusiness get _conversationBusiness => getIt<ConversationBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> tableUpdatesBody) async {
    final tableUpdates = tableUpdatesBody['tableUpdates'] as List?;
    if (tableUpdates == null) return;

    for (final update in tableUpdates) {
      final table = update['table'] as String?;
      final conversationId = update['conversationId'] as String?;
      final data = update['data'] as List?;

      if (table == 'conversations' && conversationId != null && data != null) {
        for (final item in data) {
          final version = item['version'] as int?;
          if (version != null) {
            await _conversationBusiness.syncConversationByVersion(
              conversationId,
              version,
            );
          }
        }
      }
    }
  }
}

final conversationReceiver = ConversationReceiver();
