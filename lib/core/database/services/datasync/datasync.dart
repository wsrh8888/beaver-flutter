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

final _logger = Logger('db-datasync-datasync');

class DatasyncService extends BaseService {
  const DatasyncService();

  Future<DatasyncData?> get(String module) async {
    try {

    return (db.select(db.datasync)..where((t) => t.module.equals(module))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'DatasyncService.get 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<void> upsert(String module, int? version, int updatedAt) async {
    try {

    final existing = await get(module);
    if (existing != null) {
      await (db.update(db.datasync)..where((t) => t.module.equals(module))).write(
        DatasyncCompanion(
          version: Value(version),
          updatedAt: Value(updatedAt),
        ),
      );
    } else {
      await db.into(db.datasync).insert(
        DatasyncCompanion(
          module: Value(module),
          version: Value(version),
          updatedAt: Value(updatedAt),
        ),
      );
    }
    } catch (e, st) {
      _logger.warn({'text':'DatasyncService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
