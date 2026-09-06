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

final _logger = Logger('db-emoji-collect');

class EmojiCollectService extends BaseService {
  const EmojiCollectService();

  Future<void> batchCreate(List<EmojiCollectTableCompanion> entries) async {
    try {
    _logger.info({'text':'EmojiCollectService.batchCreate 开始执行','data':{}});

    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiCollectTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiCollectTable.emojiCollectId],
          ),
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'EmojiCollectService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<Map<String, EmojiCollectTableData>> getCollectsByIds(
    List<String> ids,
  ) async {
    try {

    final query = db.select(db.emojiCollectTable)
      ..where((t) => t.emojiCollectId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.emojiCollectId: item};
    } catch (e, st) {
      _logger.warn({'text':'EmojiCollectService.getCollectsByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<List<EmojiCollectTableData>> getAll() async {
    try {
    _logger.info({'text':'EmojiCollectService.getAll 开始执行','data':{}});

    return await db.select(db.emojiCollectTable).get();
    } catch (e, st) {
      _logger.warn({'text':'EmojiCollectService.getAll 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<List<EmojiCollectTableData>> getUserCollects({
    int page = 1,
    int size = 500,
  }) async {
    try {

    final query = db.select(db.emojiCollectTable)
      ..where((t) => t.isDeleted.equals(0))
      ..limit(size, offset: (page - 1) * size);
    return await query.get();
    } catch (e, st) {
      _logger.warn({'text':'EmojiCollectService.getUserCollects 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
