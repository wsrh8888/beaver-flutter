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

class EmojiPackageSync {
  Future<void> sync(List<IEmojiPackageVersionItem> versions) async {
    final emojiPackageService = getIt<EmojiPackageService>();
    final ids = versions.map((v) => v.packageId).toList();

    print("开始同步表情包：${ids.length}");

    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(
        i,
        i + batchSize > ids.length ? ids.length : i + batchSize,
      );
      final detailRes = await getEmojiPackagesByIdsApi({'ids': batchIds});
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.packages.map((item) {
          return EmojiPackageTableCompanion(
            packageId: Value(item.packageId),
            title: Value(item.title),
            coverFile: Value(item.coverFile),
            userId: Value(item.userId),
            description: Value(item.description),
            type: Value(item.type),
            status: Value(item.status),
            version: Value(item.version),
            createdAt: Value(item.createdAt),
            updatedAt: Value(item.updatedAt),
          );
        }).toList();
        await emojiPackageService.batchCreate(companions);
      }
    }
  }
}
