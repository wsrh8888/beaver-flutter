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

import 'package:beaver/features/ai/types/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiToolMessage extends StatefulWidget {
  final List<AiToolStep> tools;

  const AiToolMessage({super.key, required this.tools});

  @override
  State<AiToolMessage> createState() => _AiToolMessageState();
}

class _AiToolMessageState extends State<AiToolMessage> {
  bool _open = false;

  String get _title {
    final count = widget.tools.length;
    if (widget.tools.any((item) => item.status == AiToolStatus.running)) {
      return '进行中 · $count 步';
    }
    if (widget.tools.any((item) => item.status == AiToolStatus.error)) {
      return '过程 · $count 步，有失败';
    }
    return '过程 · $count 步';
  }

  String _statusText(AiToolStatus status) {
    switch (status) {
      case AiToolStatus.running:
        return '进行中';
      case AiToolStatus.error:
        return '失败';
      case AiToolStatus.done:
        return '完成';
    }
  }

  String _detailOf(AiToolStep tool) {
    final text = (tool.path.isNotEmpty ? tool.path : tool.inputText).replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.length <= 96) return text;
    return '${text.substring(0, 96)}…';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tools.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_title, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72))),
                Icon(_open ? Icons.expand_less : Icons.expand_more, size: 18.sp, color: const Color(0xFF636E72)),
              ],
            ),
          ),
        ),
        if (_open)
          ...widget.tools.map((tool) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFEBEEF5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(tool.label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      ),
                      Text(_statusText(tool.status), style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72))),
                    ],
                  ),
                  if (_detailOf(tool).isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        _detailOf(tool),
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72), height: 1.4),
                      ),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
