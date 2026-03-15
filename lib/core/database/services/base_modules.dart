import 'package:drift/drift.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/core/database/services/base.dart';

class EmojiService extends BaseService {
  EmojiService(super.db);

  /// 批量创建表情
  Future<void> batchCreateEmojis(List<EmojisCompanion> emojis) async {
    await db.batch((batch) {
      for (final e in emojis) {
        batch.insert(db.emojis, e, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

class NotificationService extends BaseService {
  NotificationService(super.db);

  /// 批量创建通知事件
  Future<void> batchCreateEvents(List<NotificationEventsCompanion> events) async {
    await db.batch((batch) {
      for (final e in events) {
        batch.insert(db.notificationEvents, e, mode: InsertMode.insertOrReplace);
      }
    });
  }
}
