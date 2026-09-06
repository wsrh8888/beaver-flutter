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

import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/database/services/emoji/package_emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

final _logger = Logger('business-package-emoji');

abstract class PackageEmojiBusinessInterface {
  Future<List<EmojiModel>> getPackageEmojis(String packageId);
}

class PackageEmojiBusiness implements PackageEmojiBusinessInterface {
  final _emojiPackageEmojiService = getIt<EmojiPackageEmojiService>();

  @override
  Future<List<EmojiModel>> getPackageEmojis(String packageId) async {
    _logger.info({'text': '获取表情包内表情', 'data': {'packageId': packageId}});
    try {
      final emojis = await _emojiPackageEmojiService.getEmojisByPackageId(packageId);
      return emojis.map((emoji) => EmojiModel(
        emojiId: emoji.emojiId,
        name: emoji.title,
        fileKey: emoji.fileKey,
        version: emoji.version,
        packageId: packageId,
      )).toList();
    } catch (e) {
      _logger.warn({'text': '获取表情包内表情失败', 'data': {'packageId': packageId, 'error': e.toString()}});
      rethrow;
    }
  }
}
