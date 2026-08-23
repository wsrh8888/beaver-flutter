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

/// 缓存类型枚举
/// 放置在 lib/types 下以供 UI 和业务层共享，实现与核心缓存实现的隔离。
enum CacheType {
  image, // 聊天图片/朋友圈图片
  video, // 视频
  voice, // 语音
  avatar, // 头像
  file, // 普通文件
}

/// 文件扩展名映射
const Map<String, CacheType> fileTypeMapping = {
  '.jpg': CacheType.image,
  '.jpeg': CacheType.image,
  '.png': CacheType.image,
  '.gif': CacheType.image,
  '.bmp': CacheType.image,
  '.webp': CacheType.image,
  '.mp4': CacheType.video,
  '.avi': CacheType.video,
  '.mov': CacheType.video,
  '.wmv': CacheType.video,
  '.flv': CacheType.video,
  '.mkv': CacheType.video,
  '.mp3': CacheType.voice,
  '.wav': CacheType.voice,
  '.aac': CacheType.voice,
  '.ogg': CacheType.voice,
  '.m4a': CacheType.voice,
};
