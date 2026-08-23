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

import 'package:beaver/types/cache.dart';

/// 缓存类型映射配置
class CachePathConfig {
  static const String brandFolder = 'beaver';

  static String userCacheRoot(String userId) {
    return '$brandFolder/users/$userId/cache';
  }

  static String userDbRoot(String userId) {
    return '$brandFolder/users/$userId/db';
  }

  /// 按日期分目录，例如 2026/06/06
  static String getDateFolder([DateTime? date]) {
    final d = date ?? DateTime.now();
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}/$month/$day';
  }

  static String getSubFolder(CacheType type) {
    switch (type) {
      case CacheType.image:
        return 'images';
      case CacheType.video:
        return 'videos';
      case CacheType.voice:
        return 'voices';
      case CacheType.avatar:
        return 'avatars';
      case CacheType.file:
        return 'files';
    }
  }

  /// images/2026/06/06
  static String getRelativePath(CacheType type, String userId, [DateTime? date]) {
    return '${userCacheRoot(userId)}/${getSubFolder(type)}/${getDateFolder(date)}';
  }
}
