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
import 'package:beaver/core/database/services/emoji/collect.dart';
import 'package:beaver/core/database/services/emoji/emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

final _logger = Logger('business-favorite-emoji');

abstract class FavoriteEmojiBusinessInterface {
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500});
}

class FavoriteEmojiBusiness implements FavoriteEmojiBusinessInterface {
  final _emojiCollectService = getIt<EmojiCollectService>();
  final _emojiService = getIt<EmojiService>();
  
  @override
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500}) async {
    _logger.info({'text': '获取用户收藏表情', 'data': {'page': page, 'size': size}});
    try {
      final collects = await _emojiCollectService.getUserCollects(page: page, size: size);
      if (collects.isEmpty) return [];

      final emojiIds = collects.map((c) => c.emojiId).toList();
      final emojis = await _emojiService.getEmojisByIds(emojiIds);

      return collects.map((collect) {
        final emoji = emojis[collect.emojiId];
        return FavoriteEmojiModel(
          emojiId: collect.emojiId,
          fileKey: emoji?.fileKey ?? '',
          title: emoji?.title ?? '',
          packageId: collect.packageId,
        );
      }).toList();
    } catch (e) {
      _logger.warn({'text': '获取用户收藏表情失败', 'data': {'page': page, 'size': size, 'error': e.toString()}});
      rethrow;
    }
  }
}
