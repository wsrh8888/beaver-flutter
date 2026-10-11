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

import 'package:beaver/store/ai/ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiMarkdownMessage extends StatelessWidget {
  final AiMessage message;

  const AiMarkdownMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final data = message.content.isEmpty && message.streaming ? '正在思考…' : message.content;
    const textColor = Color(0xFF2D3436);
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(fontSize: 15.sp, height: 1.55, color: textColor),
        h1: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor),
        h2: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: textColor),
        h3: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: textColor),
        listBullet: TextStyle(fontSize: 15.sp, color: textColor),
        code: TextStyle(fontSize: 12.sp, color: textColor, backgroundColor: const Color(0xFFF0F0F0)),
        codeblockDecoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6.r),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: const Color(0xFFFF7D45), width: 3.w)),
        ),
        a: TextStyle(color: const Color(0xFFFF7D45), decoration: TextDecoration.underline),
      ),
    );
  }
}
