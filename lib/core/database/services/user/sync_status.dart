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
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-user-sync_status');

class UserSyncStatusService extends BaseService {
  const UserSyncStatusService();

  /// 获取用户同步状态
  Future<UserSyncStatusData?> getUserSyncStatus(String userId) async {
    try {

    return (db.select(db.userSyncStatus)..where((t) => t.userId.equals(userId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.getUserSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量获取用户同步状态
  Future<List<UserSyncStatusData>> getUsersSyncStatus(List<String> userIds) async {
    try {

    if (userIds.isEmpty) {
      return [];
    }
    return (db.select(db.userSyncStatus)..where((t) => t.userId.isIn(userIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.getUsersSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取所有用户同步状态
  Future<List<UserSyncStatusData>> getAllUsersSyncStatus() async {
    try {
    _logger.info({'text':'UserSyncStatusService.getAllUsersSyncStatus 开始执行','data':{}});

    return db.select(db.userSyncStatus).get();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.getAllUsersSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新或插入用户同步状态
  Future<void> upsertUserSyncStatus(String userId, int userVersion) async {
    try {

    await db.into(db.userSyncStatus).insert(
          UserSyncStatusCompanion(
            userId: Value(userId),
            userVersion: Value(userVersion),
            lastSyncTime: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.upsertUserSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量更新用户同步状态
  Future<void> batchUpsertUserSyncStatus(List<Map<String, dynamic>> statuses) async {
    try {
    _logger.info({'text':'UserSyncStatusService.batchUpsertUserSyncStatus 开始执行','data':{}});

    await db.batch((batch) {
      for (final status in statuses) {
        batch.insert(
          db.userSyncStatus,
          UserSyncStatusCompanion(
            userId: Value(status['userId'] as String),
            userVersion: Value(status['userVersion'] as int),
            lastSyncTime: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.batchUpsertUserSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 删除用户同步状态
  Future<void> deleteUserSyncStatus(String userId) async {
    try {

    await (db.delete(db.userSyncStatus)..where((t) => t.userId.equals(userId))).go();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.deleteUserSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量删除用户同步状态
  Future<void> batchDeleteUserSyncStatus(List<String> userIds) async {
    try {
    _logger.info({'text':'UserSyncStatusService.batchDeleteUserSyncStatus 开始执行','data':{}});

    if (userIds.isEmpty) {
      return;
    }
    await (db.delete(db.userSyncStatus)..where((t) => t.userId.isIn(userIds))).go();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.batchDeleteUserSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 清空所有同步状态（用于重置）
  Future<void> clearAllSyncStatus() async {
    try {
    _logger.info({'text':'UserSyncStatusService.clearAllSyncStatus 开始执行','data':{}});

    await db.delete(db.userSyncStatus).go();
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.clearAllSyncStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取需要同步的用户列表
  Future<List<String>> getUsersNeedSync(Map<String, int> serverVersions) async {
    try {

    final localStatuses = await getAllUsersSyncStatus();
    final statusMap = <String, UserSyncStatusData>{};
    for (final status in localStatuses) {
      statusMap[status.userId] = status;
    }

    final needSync = <String>[];
    for (final entry in serverVersions.entries) {
      final userId = entry.key;
      final serverVersion = entry.value;
      final localStatus = statusMap[userId];
      final localVersion = localStatus?.userVersion ?? 0;

      if (localVersion < serverVersion) {
        needSync.add(userId);
      }
    }

    return needSync;
    } catch (e, st) {
      _logger.warn({'text':'UserSyncStatusService.getUsersNeedSync 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
