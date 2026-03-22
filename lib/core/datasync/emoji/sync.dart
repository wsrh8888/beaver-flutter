import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/datasync/emoji/collect.dart';
import 'package:beaver/core/datasync/emoji/detail.dart';
import 'package:beaver/core/datasync/emoji/package.dart';
import 'package:beaver/core/datasync/emoji/package_collect.dart';
import 'package:beaver/core/datasync/emoji/package_emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';

class EmojiSync {
  Future<void> checkAndSync() async {
    print('[EmojiSync] 开始同步表情数据');
    try {
      // 1. 同步表情详情
      await EmojiDetailSync().sync();

      // 2. 同步收藏与关联数据
      await _syncEmojiCollects();

      print('[EmojiSync] 表情同步完成');
    } catch (e) {
      print('[EmojiSync] 同步过程中发生错误: $e');
    }
  }

  Future<void> _syncEmojiCollects() async {
    final datasyncService = getIt<DatasyncService>();

    final cursor = await datasyncService.get('emoji_collects');
    final lastSyncTime = cursor?.version ?? 0;

    final response = await datasyncGetSyncEmojiCollectsApi(
      IGetSyncEmojiCollectsReq(since: lastSyncTime),
    );
    if (response.code != 0 || response.result == null) return;

    final result = response.result!;

    // 1. 同步表情收藏详情 (Collects)
    if (result.emojiCollectVersions.isNotEmpty) {
      await EmojiCollectSync().sync(result.emojiCollectVersions);
    }

    // 2. 同步表情包元数据 (Packages)
    if (result.emojiPackageVersions.isNotEmpty) {
      await EmojiPackageSync().sync(result.emojiPackageVersions);
    }

    // 3. 同步表情包订阅记录 (PackageCollects)
    if (result.emojiPackageCollectVersions.isNotEmpty) {
      await EmojiPackageCollectSync().sync(result.emojiPackageCollectVersions);
    }

    // 4. 同步表情包内容详情 (PackageContents)
    if (result.emojiPackageContentVersions.isNotEmpty) {
      await EmojiPackageEmojiSync().sync(result.emojiPackageContentVersions);
    }

    // 更新游标 (使用 serverTimestamp 作为版本号实现真正的增量同步)
    await datasyncService.upsert(
      'emoji_collects',
      result.serverTimestamp,
      result.serverTimestamp,
    );
  }
}

/// 清空表情同步状态与本地数据 (用于调试或重置)
Future<void> clearEmojiSyncState() async {
  final datasyncService = getIt<DatasyncService>();
  final db = DatabaseManager.instance;
  
  await datasyncService.upsert('emoji_collects', 0, 0);
  await datasyncService.upsert('emojis', 0, 0);
  
  await db.batch((batch) {
    batch.deleteAll(db.emojiCollectTable);
    batch.deleteAll(db.emojiPackageTable);
    batch.deleteAll(db.emojiPackageCollectTable);
    batch.deleteAll(db.emojiPackageEmojiTable);
    batch.deleteAll(db.emojis);
  });
  
  print('[EmojiSync] 表情同步状态与本地数据已清空');
}

final emojiSync = EmojiSync();
