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

import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:drift/drift.dart';

class EmojiPackageService extends BaseService {
  const EmojiPackageService();

  Future<void> batchCreate(List<EmojiPackageTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiPackageTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiPackageTable.packageId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiPackageTableData>> getPackagesByIds(
    List<String> ids,
  ) async {
    final query = db.select(db.emojiPackageTable)
      ..where((t) => t.packageId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageId: item};
  }

  Future<List<EmojiPackageTableData>> getAll() async {
    return await db.select(db.emojiPackageTable).get();
  }

  Future<List<EmojiPackageTableData>> getPackages({
    int page = 1,
    int size = 200,
  }) async {
    final query = db.select(db.emojiPackageTable)
      ..limit(size, offset: (page - 1) * size);
    return await query.get();
  }
}
