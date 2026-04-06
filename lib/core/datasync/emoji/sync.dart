import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/datasync/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';

class EmojiSync {
  Future<void> checkAndSync() async {
    try {
      // 1. 同步表情详情
      await EmojiDetailSync().sync();

      // 2. 同步收藏与关联数据
      await _syncEmojiCollects();
    } catch (e) {
      print('[EmojiSync] 同步过程中发生错误: $e');
    }
  }

  Future<void> _syncEmojiCollects() async {
    final datasyncService = getIt<DatasyncService>();

    final cursor = await datasyncService.get('emoji_collects');
    final lastSyncTime = cursor?.updatedAt ?? 0;

    final response = await datasyncGetSyncEmojiCollectsApi(
      IGetSyncEmojiCollectsReq(since: lastSyncTime),
    );
    if (response.code != 0 || response.result == null) return;

    final result = response.result!;

    // 对标 PC：并行执行所有表情包相关表的同步
    final syncTasks = <Future<void>>[];

    // 1. 同步单个表情收藏详情 (Collects)
    if (result.emojiCollectVersions.isNotEmpty) {
      print('同步表情收藏详情');
      syncTasks.add(EmojiCollectSync().sync(result.emojiCollectVersions));
    }

    // 2. 同步表情包元数据 (Packages)
    if (result.emojiPackageVersions.isNotEmpty) {
      print('同步表情包元数据');
      syncTasks.add(EmojiPackageSync().sync(result.emojiPackageVersions));
    }

    // 3. 同步表情包订阅记录 (PackageCollects)
    if (result.emojiPackageCollectVersions.isNotEmpty) {
      print('同步表情包订阅记录');
      syncTasks.add(
        EmojiPackageCollectSync().sync(result.emojiPackageCollectVersions),
      );
    }

    // 4. 同步表情包内容详情 (PackageContents)
    if (result.emojiPackageContentVersions.isNotEmpty) {
      print('同步表情包内容详情');
      syncTasks.add(
        EmojiPackageEmojiSync().sync(result.emojiPackageContentVersions),
      );
    }

    // 并行处理并等待完成
    if (syncTasks.isNotEmpty) {
      await Future.wait(syncTasks);
    }

    // 更新游标 (使用 serverTimestamp 实现增量同步)
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
