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

class GroupSyncStatusService extends BaseService {
  const GroupSyncStatusService();

  /// 批量获取指定模块的版本状态
  Future<List<Map<String, dynamic>>> getModuleVersions(String module, List<String> groupIds) async {
    if (groupIds.isEmpty) {
      return [];
    }

    final statuses = await (db.select(db.groupSyncStatus)
          ..where((t) => t.module.equals(module) & t.groupId.isIn(groupIds)))
        .get();

    final versions = statuses.map((status) => {
          'groupId': status.groupId,
          'version': status.version ?? 0,
        }).toList();

    return versions;
  }

  /// 更新指定模块的同步状态
  Future<void> upsertSyncStatus({
    required String module,
    required String groupId,
    required int version,
  }) async {
    await db.into(db.groupSyncStatus).insert(
          GroupSyncStatusCompanion(
            module: Value(module),
            groupId: Value(groupId),
            version: Value(version),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
