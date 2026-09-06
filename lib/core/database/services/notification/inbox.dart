/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import '../base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-notification-inbox');

// 通知收件箱服务
class NotificationInboxService extends BaseService {
  const NotificationInboxService();

  /**
   * @description 创建通知收件箱记录
   */
  Future<void> create(Map<String, dynamic> req) async {
    try {

    await db
        .into(db.notificationInboxTable)
        .insert(
          NotificationInboxTableCompanion(
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
            createdAt: Value(
              req['createdAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
            updatedAt: Value(
              req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
          ),
        );
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.create 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 批量创建通知收件箱记录（upsert操作）
   */
  Future<void> batchCreate(Map<String, dynamic> req) async {
    try {
    _logger.info({'text':'NotificationInboxService.batchCreate 开始执行','data':{}});

    final inboxes = req['inboxes'] as List<dynamic>;
    if (inboxes.isEmpty) {
      return;
    }

    for (final inboxData in inboxes) {
      await db
          .into(db.notificationInboxTable)
          .insert(
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
              createdAt: Value(
                inboxData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
              updatedAt: Value(
                inboxData['updatedAt'] ??
                    DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 根据用户ID和分类获取通知列表
   */
  Future<List<dynamic>> getInboxByUserIdAndCategory(
    Map<String, dynamic> req,
  ) async {
    try {

    final userId = req['userId'] as String;
    final category = req['category'] as String;
    final result =
        await (db.select(db.notificationInboxTable)
              ..where(
                (t) => t.userId.equals(userId) & t.category.equals(category),
              )
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return result.map((item) => item.toJson()).toList();
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.getInboxByUserIdAndCategory 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 根据用户ID获取所有通知
   */
  Future<List<dynamic>> getInboxByUserId(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final result =
        await (db.select(db.notificationInboxTable)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return result.map((item) => item.toJson()).toList();
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.getInboxByUserId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 标记通知为已读
   */
  Future<void> markAsRead(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final eventId = req['eventId'] as String;
    await (db.update(
      db.notificationInboxTable,
    )..where((t) => t.userId.equals(userId) & t.eventId.equals(eventId))).write(
      NotificationInboxTableCompanion(
        isRead: const Value(1),
        readAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
    );
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.markAsRead 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 删除通知
   */
  Future<void> delete(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final eventId = req['eventId'] as String;
    await (db.delete(
      db.notificationInboxTable,
    )..where((t) => t.userId.equals(userId) & t.eventId.equals(eventId))).go();
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.delete 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
  /**
   * @description 获取特定时间后的未读通知数
   */
  Future<int> getUnreadCountAfterTime({
    required String userId,
    required String category,
    required int afterTime,
  }) async {
    try {

    final query =
        db.select(db.notificationInboxTable)..where(
          (t) =>
              t.userId.equals(userId) &
              t.category.equals(category) &
              t.createdAt.isBiggerThanValue(afterTime) &
              t.isRead.equals(0),
        );
    final results = await query.get();
    return results.length;
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.getUnreadCountAfterTime 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<Map<String, int>> getVersionMapByEventIds({
    required String userId,
    required List<String> eventIds,
  }) async {
    try {

    if (eventIds.isEmpty) return {};

    final rows = await (db.select(db.notificationInboxTable)..where(
          (t) => t.userId.equals(userId) & t.eventId.isIn(eventIds),
        ))
        .get();

    return {for (final row in rows) row.eventId: row.version ?? 0};
    } catch (e, st) {
      _logger.warn({'text':'NotificationInboxService.getVersionMapByEventIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
