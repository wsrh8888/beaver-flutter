import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class NotificationEventService extends BaseService {
  NotificationEventService(super.db);

  /// 批量创建通知事件
  Future<void> batchCreate(List<NotificationEventsCompanion> events) async {
    if (events.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final event in events) {
        batch.insert(
          db.notificationEvents,
          event,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 按版本增量拉取事件
  Future<List<NotificationEvent>> getEventsAfterVersion(int version, {int limit = 100}) async {
    return (db.select(db.notificationEvents)
          ..where((t) => t.version.isBiggerThanValue(version))
          ..orderBy([(t) => OrderingTerm(expression: t.version)])
          ..limit(limit))
        .get();
  }

  /// 获取指定事件ID的本地版本映射
  Future<Map<String, int>> getVersionMapByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return {};
    }

    final rows = await (db.select(db.notificationEvents)..where((t) => t.eventId.isIn(eventIds))).get();

    final versionMap = <String, int>{};
    for (final row in rows) {
      versionMap[row.eventId] = row.version ?? 0;
    }

    return versionMap;
  }

  /// 根据事件ID列表获取事件明细
  Future<List<NotificationEvent>> getByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return [];
    }

    return (db.select(db.notificationEvents)..where((t) => t.eventId.isIn(eventIds))).get();
  }
}
