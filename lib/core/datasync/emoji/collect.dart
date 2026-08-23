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

import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiCollectSync {
  Future<void> sync(List<IEmojiCollectVersionItem> versions) async {
    final emojiCollectService = getIt<EmojiCollectService>();
    final ids = versions.map((v) => v.emojiCollectId).toList();

    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(
        i,
        i + batchSize > ids.length ? ids.length : i + batchSize,
      );
      final detailRes = await getEmojiCollectsByIdsApi({'ids': batchIds});
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.collects.map((item) {
          return EmojiCollectTableCompanion(
            emojiCollectId: Value(item.emojiCollectId),
            userId: Value(item.userId),
            emojiId: Value(item.emojiId),
            packageId: Value(item.packageId),
            version: Value(item.version),
            isDeleted: Value(item.isDeleted ? 1 : 0),
            createdAt: Value(item.createdAt),
            updatedAt: Value(item.updatedAt),
          );
        }).toList();
        await emojiCollectService.batchCreate(companions);
      }
    }
  }
}
