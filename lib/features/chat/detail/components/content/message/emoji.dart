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

import 'dart:math';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiMessage extends StatelessWidget {
  final EmojiMsg msg;
  const EmojiMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    // 参考桌面端逻辑计算尺寸 (max: 120, min: 32)
    final double rawWidth = (msg.width ?? 64).toDouble();
    final double rawHeight = (msg.height ?? 64).toDouble();

    const double maxSize = 120.0;
    const double minSize = 32.0;

    double width = rawWidth;
    double height = rawHeight;

    if (width > maxSize || height > maxSize) {
      final double ratio = min(maxSize / width, maxSize / height);
      width = max(minSize, width * ratio);
      height = max(minSize, height * ratio);
    } else {
      width = max(minSize, width);
      height = max(minSize, height);
    }

    // 仅使用 BeaverCachedImage 渲染，由 fileUrl 决定内容同步
    return BeaverCachedImage(
      fileUrl: msg.fileUrl,
      width: width.w,
      height: height.w,
      fit: BoxFit.contain,
      borderRadius: 6.w,
      enableFullscreen: false,
    );
  }
}
