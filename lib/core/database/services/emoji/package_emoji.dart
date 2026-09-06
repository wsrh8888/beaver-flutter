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
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-emoji-package_emoji');

class EmojiPackageEmojiService extends BaseService {
  const EmojiPackageEmojiService();

  Future<void> batchCreate(
    List<EmojiPackageEmojiTableCompanion> entries,
  ) async {
    try {
    _logger.info({'text':'EmojiPackageEmojiService.batchCreate 开始执行','data':{}});

    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiPackageEmojiTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiPackageEmojiTable.relationId],
          ),
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'EmojiPackageEmojiService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<List<EmojiPackageEmojiTableData>> getByPackageId(
    String packageId,
  ) async {
    try {

    final query = db.select(db.emojiPackageEmojiTable)
      ..where((t) => t.packageId.equals(packageId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return await query.get();
    } catch (e, st) {
      _logger.warn({'text':'EmojiPackageEmojiService.getByPackageId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<List<Emoji>> getEmojisByPackageId(String packageId) async {
    try {

    final query = db.select(db.emojis).join([
      innerJoin(
        db.emojiPackageEmojiTable,
        db.emojiPackageEmojiTable.emojiId.equalsExp(db.emojis.emojiId),
      ),
    ]);
    query.where(db.emojiPackageEmojiTable.packageId.equals(packageId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.emojis)).toList();
    } catch (e, st) {
      _logger.warn({'text':'EmojiPackageEmojiService.getEmojisByPackageId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
