import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';
import 'package:beaver/core/database/tables/notification/read.dart';

// 通知已读游标服务
class NotificationReadCursorService extends BaseService {
  NotificationReadCursorService(AppDatabase db) : super(db);

  /**
   * @description 创建或更新已读游标
   */
  Future<void> upsert(Map<String, dynamic> req) async {
    await db.into(db.notificationReadTable).insert(
      NotificationReadTableCompanion(
        userId: Value(req['userId']),
        category: Value(req['category']),
        version: Value(req['version'] ?? 0),
        lastReadAt: Value(req['lastReadAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        createdAt: Value(req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /**
   * @description 根据用户ID和分类获取已读游标
   */
  Future<dynamic> getReadCursor(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final category = req['category'] as String;
    final result = await db.select(db.notificationReadTable)
      .where((t) => t.userId.equals(userId) & t.category.equals(category))
      .get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 根据用户ID获取所有已读游标
   */
  Future<List<dynamic>> getReadCursorsByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await db.select(db.notificationReadTable)
      .where((t) => t.userId.equals(userId))
      .get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 更新已读游标
   */
  Future<void> update(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final category = req['category'] as String;
    final updates = <SetColumn, Expression>{};
    if (req.containsKey('version')) updates[db.notificationReadTable.version] = Value(req['version']);
    if (req.containsKey('lastReadAt')) {
      updates[db.notificationReadTable.lastReadAt] = Value(req['lastReadAt']);
    } else {
      updates[db.notificationReadTable.lastReadAt] = Value(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    }
    if (req.containsKey('updatedAt')) {
      updates[db.notificationReadTable.updatedAt] = Value(req['updatedAt']);
    } else {
      updates[db.notificationReadTable.updatedAt] = Value(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    }

    await db.update(db.notificationReadTable)
      .set(updates)
      .where((t) => t.userId.equals(userId) & t.category.equals(category))
      .go();
  }
}
