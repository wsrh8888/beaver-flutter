import 'package:beaver/core/database/database.dart';
import 'package:beaver/di/injection.dart';

import '../base/base.dart';

/// 会话业务 (对标 desktop business/chat/conversation.ts)
class ConversationBusiness extends BaseBusiness<QueueItem> {
  ConversationBusiness() : super(BusinessBatchConfig(queueSizeLimit: 30, delayMs: 1000));

  @override
  String get businessName => 'ConversationBusiness';

  @override
  Future<void> processBatchRequests(List<QueueItem> items) async {}

  Future<Map<String, dynamic>> getRecentChatList({required String userId, int limit = 50}) async {
    final conversationService = getIt<ConversationService>();
    final list = await conversationService.getAll();
    return {'count': list.length, 'list': list};
  }
}
