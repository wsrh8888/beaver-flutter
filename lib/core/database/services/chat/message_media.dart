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
import 'package:beaver/core/database/services/base.dart';

class ChatMessageMediaService extends BaseService {
  const ChatMessageMediaService();

  Future<void> _ensureTable() async {
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS chat_message_medias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        message_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT 0,
        UNIQUE (user_id, message_id)
      )
    ''');
  }

  Future<List<String>> getMessageIds(String userId) async {
    if (userId.isEmpty) {
      return [];
    }

    await _ensureTable();
    final rows = await db
        .customSelect(
          'SELECT message_id FROM chat_message_medias WHERE user_id = ?',
          variables: [Variable.withString(userId)],
          readsFrom: const {},
        )
        .get();
    return rows.map((row) => row.read<String>('message_id')).toList();
  }

  Future<void> batchCreate(String userId, List<String> messageIds) async {
    if (userId.isEmpty || messageIds.isEmpty) {
      return;
    }

    await _ensureTable();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await db.batch((batch) {
      for (final messageId in messageIds) {
        if (messageId.isEmpty) {
          continue;
        }
        batch.customStatement(
          'INSERT OR IGNORE INTO chat_message_medias (user_id, message_id, version, created_at) VALUES (?, ?, 0, ?)',
          [userId, messageId, now],
        );
      }
    });
  }
}
