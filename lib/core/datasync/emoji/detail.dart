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

import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiDetailSync {
  Future<void> sync() async {
    final datasyncService = getIt<DatasyncService>();
    final emojiService = getIt<EmojiService>();

    final cursor = await datasyncService.get('emojis');
    final lastSyncTime = cursor?.updatedAt ?? 0;

    final response = await datasyncGetSyncEmojisApi(
      IGetSyncEmojisReq(since: lastSyncTime),
    );
    if (response.code != 0 || response.result == null) return;

    final emojiVersions = response.result!.emojiVersions;
    if (emojiVersions.isEmpty) {
      await datasyncService.upsert(
        'emojis',
        lastSyncTime,
        response.result!.serverTimestamp,
      );
      return;
    }

    final ids = emojiVersions.map((v) => v.emojiId).toList();
    final localEmojis = await emojiService.getEmojisByIds(ids);

    final needUpdateIds = ids.where((id) {
      final local = localEmojis[id];
      final serverVersion = emojiVersions
          .firstWhere((v) => v.emojiId == id)
          .version;
      return local == null || local.version < serverVersion;
    }).toList();

    if (needUpdateIds.isNotEmpty) {
      const batchSize = 50;
      for (var i = 0; i < needUpdateIds.length; i += batchSize) {
        final batchIds = needUpdateIds.sublist(
          i,
          i + batchSize > needUpdateIds.length
              ? needUpdateIds.length
              : i + batchSize,
        );
        final detailRes = await getEmojisByIdsApi({'ids': batchIds});
        if (detailRes.code == 0 && detailRes.result != null) {
          final List emojisJson = detailRes.result['emojis'] as List;
          final emojis = emojisJson.map((json) {
            return EmojisCompanion(
              emojiId: Value(json['emojiId']),
              fileKey: Value(json['fileKey']),
              title: Value(json['title']),
              emojiInfo: Value(json['emojiInfo']?.toString()),
              status: Value(json['status'] ?? 1),
              version: Value(json['version'] ?? 0),
              createdAt: Value(json['createdAt'] ?? 0),
              updatedAt: Value(json['updatedAt'] ?? 0),
            );
          }).toList();
          await emojiService.batchCreate(emojis);
        }
      }
    }

    final maxVersion = emojiVersions
        .map((v) => v.version)
        .fold(lastSyncTime, (a, b) => a > b ? a : b);
    await datasyncService.upsert(
      'emojis',
      maxVersion,
      response.result!.serverTimestamp,
    );
  }
}
