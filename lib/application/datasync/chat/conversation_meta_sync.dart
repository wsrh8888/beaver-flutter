import 'package:beaver/shared/utils/storage_util.dart';

/// 会话元数据同步 (对标 desktop datasync/chat/conversation-meta.ts)
class ConversationMetaSync {
  Future<void> checkAndSync() async {
    if (StorageUtil.getString('userId') == null) return;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
