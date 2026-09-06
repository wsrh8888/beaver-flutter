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

final _logger = Logger('db-notification-read_cursor');

// 通知已读游标服务
class NotificationReadCursorService extends BaseService {
  const NotificationReadCursorService();

  /**
   * @description 创建或更新已读游标
   */
  Future<void> upsert(Map<String, dynamic> req) async {
    try {

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
    } catch (e, st) {
      _logger.warn({'text':'NotificationReadCursorService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 根据用户ID和分类获取已读游标
   */
  Future<dynamic> getReadCursor(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final category = req['category'] as String;
    final result = await (db.select(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId) & t.category.equals(category)))
      .get();
    return result.isNotEmpty ? result.first.toJson() : null;
    } catch (e, st) {
      _logger.warn({'text':'NotificationReadCursorService.getReadCursor 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 根据用户ID获取所有已读游标
   */
  Future<List<dynamic>> getReadCursorsByUserId(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final result = await (db.select(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId)))
      .get();
    return result.map((item) => item.toJson()).toList();
    } catch (e, st) {
      _logger.warn({'text':'NotificationReadCursorService.getReadCursorsByUserId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /**
   * @description 更新已读游标
   */
  Future<void> update(Map<String, dynamic> req) async {
    try {

    final userId = req['userId'] as String;
    final category = req['category'] as String;

    await (db.update(db.notificationReadTable)
      ..where((t) => t.userId.equals(userId) & t.category.equals(category)))
      .write(NotificationReadTableCompanion(
        version: req.containsKey('version') ? Value(req['version']) : const Value.absent(),
        lastReadAt: Value(req['lastReadAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
        updatedAt: Value(req['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ));
    } catch (e, st) {
      _logger.warn({'text':'NotificationReadCursorService.update 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
