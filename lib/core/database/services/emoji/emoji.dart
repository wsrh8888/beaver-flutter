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

final _logger = Logger('db-emoji-emoji');

class EmojiService extends BaseService {
  const EmojiService();

  Future<void> batchCreate(List<EmojisCompanion> entries) async {
    try {
    _logger.info({'text':'EmojiService.batchCreate 开始执行','data':{}});

    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojis,
          entry,
          onConflict: DoUpdate((old) => entry, target: [db.emojis.emojiId]),
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'EmojiService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<Map<String, Emoji>> getEmojisByIds(List<String> ids) async {
    try {

    final query = db.select(db.emojis)..where((t) => t.emojiId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.emojiId: item};
    } catch (e, st) {
      _logger.warn({'text':'EmojiService.getEmojisByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<Emoji?> getEmojiById(String id) async {
    try {

    return await (db.select(
      db.emojis,
    )..where((t) => t.emojiId.equals(id))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'EmojiService.getEmojiById 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
