import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/store/message_media/message_media.dart';

/// 消息媒体状态同步器（语音已听等）
class MessageMediaSync {
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) {
      return;
    }
    await getIt<MessageMediaStore>().sync();
  }
}

final messageMediaSync = MessageMediaSync();
