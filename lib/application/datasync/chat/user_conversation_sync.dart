import 'package:beaver/shared/utils/storage_util.dart';

/// 用户会话同步 (对标 desktop datasync/chat/user-conversation.ts)
class UserConversationSync {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
