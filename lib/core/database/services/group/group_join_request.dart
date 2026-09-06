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
import 'package:beaver/types/api/group.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-group-group_join_request');

class GroupJoinRequestService extends BaseService {
  const GroupJoinRequestService();

  /// 批量创建入群申请
  Future<void> batchCreate(List<IGroupJoinRequestSyncItem> requests) async {
    try {
    _logger.info({'text':'GroupJoinRequestService.batchCreate 开始执行','data':{}});

    await db.batch((batch) {
      for (final req in requests) {
        batch.insert(
          db.groupJoinRequests,
          GroupJoinRequestsCompanion(
            id: Value(req.id), // id is already int in IGroupJoinRequestSyncItem
            groupId: Value(req.groupId),
            applicantUserId: Value(req.applicantUserId),
            message: Value(req.message),
            status: Value(req.status),
            version: Value(req.version),
            createdAt: Value(req.createdAt),
            updatedAt: Value(req.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'GroupJoinRequestService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取未读（待处理）申请数
  Future<int> getUnreadCount() async {
    try {

    // 这里简单处理：所有由于我是管理员/创建者而收到的待处理申请
    // 实际业务可能更复杂，这里先根据 status == 0 统计
    final query = db.selectOnly(db.groupJoinRequests)
      ..addColumns([db.groupJoinRequests.id.count()])
      ..where(db.groupJoinRequests.status.equals(0));
    final result = await query.map((row) => row.read<int>(db.groupJoinRequests.id.count())).getSingle();
    return result ?? 0;
    } catch (e, st) {
      _logger.warn({'text':'GroupJoinRequestService.getUnreadCount 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取所有入群申请
  Future<List<GroupJoinRequest>> getAllRequests() async {
    try {
    _logger.info({'text':'GroupJoinRequestService.getAllRequests 开始执行','data':{}});

    return await db.select(db.groupJoinRequests).get();
    } catch (e, st) {
      _logger.warn({'text':'GroupJoinRequestService.getAllRequests 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
