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

import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkdownMessage extends StatelessWidget {
  final MarkdownMsg msg;
  final bool isSelf;

  const MarkdownMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isSelf ? AppColors.chatBubbleSelfText : AppColors.chatBubbleOtherText;
    final linkColor = isSelf ? const Color(0xFFFFD4B8) : const Color(0xFFFF7D45);

    return MarkdownBody(
      data: msg.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(fontSize: 16.sp, height: 1.6, color: textColor),
        h1: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h2: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h3: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        listBullet: TextStyle(fontSize: 16.sp, color: textColor),
        code: TextStyle(
          fontSize: 12.sp,
          color: textColor,
          backgroundColor: isSelf
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFF0F0F0),
        ),
        codeblockDecoration: BoxDecoration(
          color: isSelf
              ? Colors.black.withValues(alpha: 0.2)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(5.r),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelf
                  ? Colors.white.withValues(alpha: 0.3)
                  : const Color(0xFFB2BEC3),
              width: 3.w,
            ),
          ),
        ),
        blockquote: TextStyle(
          fontSize: 16.sp,
          height: 1.6,
          color: isSelf
              ? Colors.white.withValues(alpha: 0.85)
              : const Color(0xFF636E72),
        ),
        a: TextStyle(
          color: linkColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
