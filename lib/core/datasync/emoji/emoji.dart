import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';

/// 表情同步
class EmojiSync {
  Future<void> checkAndSync() async {
    print('[EmojiSync] 开始同步表情数据');
    
    final datasyncService = getIt<DatasyncService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('emojis');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取摘要
    final response = await datasyncGetSyncEmojisApi(IGetSyncEmojisReq(since: lastSyncTime));
    
    if (response.code != 0 || response.result == null) {
      print('[EmojiSync] 获取表情版本失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比并同步具体数据 (由于目前没具体 API 同步数据，先仅更新游标)
    // TODO: 实现具体表情数据的分批同步逻辑
    
    await datasyncService.upsert('emojis', -1, serverTimestamp);
    print('[EmojiSync] 表情同步完成');
  }
}

final emojiSync = EmojiSync();
