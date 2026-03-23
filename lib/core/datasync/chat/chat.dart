import 'package:beaver/core/datasync/index.dart';

/// 聊天数据同步统一入口
class ChatDatasync {
  Future<void> checkAndSync() async {
    // 并行执行聊天相关同步器
    await Future.wait([
      userConversationSync.checkAndSync(), // 用户会话设置同步
      conversationMetaSync.checkAndSync(), // 会话元数据同步
      messageSync.checkAndSync(), // 消息同步
    ]);
  }
}

final chatDatasync = ChatDatasync();
