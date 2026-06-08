import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';

// 通知已读游标服务
class NotificationReadCursorService extends BaseService {
  const NotificationReadCursorService();

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
    final result = await (db.select(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId) & t.category.equals(category)))
      .get();
    return result.isNotEmpty ? result.first.toJson() : null;
  }

  /**
   * @description 根据用户ID获取所有已读游标
   */
  Future<List<dynamic>> getReadCursorsByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await (db.select(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId)))
      .get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 更新已读游标
   */
  Future<void> update(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final category = req['category'] as String;

    await (db.update(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId) & t.category.equals(category)))
      .write(NotificationReadTableCompanion(
        version: req.containsKey('version') ? Value(req['version']) : const Value.absent(),
        lastReadAt: Value(req['lastReadAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ));
  }
}
