import 'package:beaver/core/sync/sync_manager.dart';

/// 消息同步 (对标 desktop datasync/chat/chat-message.ts)
class MessageSync {
  Future<void> checkAndSync() async {
    print('[DataSync] 开始同步消息数据');
    await SyncManager.instance.startIncrementalSync();
    print('[DataSync] 消息同步完成');
  }
}
