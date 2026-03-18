import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';
import 'package:beaver/core/database/tables/notification/inbox.dart';

// 通知收件箱服务
class NotificationInboxService extends BaseService {
  NotificationInboxService(AppDatabase db) : super(db);

  /**
   * @description 创建通知收件箱记录
   */
  Future<void> create(Map<String, dynamic> req) async {
    await db.into(db.notificationInboxTable).insert(NotificationInboxTableCompanion(
      userId: Value(req['userId']),
      eventId: Value(req['eventId']),
      eventType: Value(req['eventType']),
      category: Value(req['category']),
      version: Value(req['version'] ?? 0),
      isRead: Value(req['isRead'] ?? 0),
      readAt: Value(req['readAt']),
      status: Value(req['status'] ?? 1),
      isDeleted: Value(req['isDeleted'] ?? 0),
      silent: Value(req['silent'] ?? 0),
      createdAt: Value(req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
    ));
  }

  /**
   * @description 批量创建通知收件箱记录（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    final inboxes = req['inboxes'] as List<dynamic>;
    if (inboxes.isEmpty) {
      return;
    }

    for (final inboxData in inboxes) {
      await db.into(db.notificationInboxTable).insert(
        NotificationInboxTableCompanion(
          userId: Value(inboxData['userId']),
          eventId: Value(inboxData['eventId']),
          eventType: Value(inboxData['eventType']),
          category: Value(inboxData['category']),
          version: Value(inboxData['version'] ?? 0),
          isRead: Value(inboxData['isRead'] ?? 0),
          readAt: Value(inboxData['readAt']),
          status: Value(inboxData['status'] ?? 1),
          isDeleted: Value(inboxData['isDeleted'] ?? 0),
          silent: Value(inboxData['silent'] ?? 0),
          createdAt: Value(inboxData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
          updatedAt: Value(inboxData['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /**
   * @description 根据用户ID和分类获取通知列表
   */
  Future<List<dynamic>> getInboxByUserIdAndCategory(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final category = req['category'] as String;
    final result = await db.select(db.notificationInboxTable)
      .where((t) => t.userId.equals(userId) & t.category.equals(category))
      .orderBy((t) => t.createdAt, order: Order.desc)
      .get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 根据用户ID获取所有通知
   */
  Future<List<dynamic>> getInboxByUserId(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final result = await db.select(db.notificationInboxTable)
      .where((t) => t.userId.equals(userId))
      .orderBy((t) => t.createdAt, order: Order.desc)
      .get();
    return result.map((item) => item.toJson()).toList();
  }

  /**
   * @description 标记通知为已读
   */
  Future<void> markAsRead(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final eventId = req['eventId'] as String;
    await db.update(db.notificationInboxTable)
      .set({
        db.notificationInboxTable.isRead: Value(1),
        db.notificationInboxTable.readAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        db.notificationInboxTable.updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      })
      .where((t) => t.userId.equals(userId) & t.eventId.equals(eventId))
      .go();
  }

  /**
   * @description 删除通知
   */
  Future<void> delete(Map<String, dynamic> req) async {
    final userId = req['userId'] as String;
    final eventId = req['eventId'] as String;
    await db.delete(db.notificationInboxTable)
      .where((t) => t.userId.equals(userId) & t.eventId.equals(eventId))
      .go();
  }
}
