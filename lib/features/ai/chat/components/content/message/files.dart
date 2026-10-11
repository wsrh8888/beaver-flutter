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

import 'package:beaver/features/ai/utils/toolEvent.dart';
import 'package:beaver/features/ai/types/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiFileCards extends StatelessWidget {
  final List<AiToolStep> tools;
  final ValueChanged<AiArtifact>? onOpenArtifact;

  const AiFileCards({super.key, required this.tools, this.onOpenArtifact});

  @override
  Widget build(BuildContext context) {
    final files = collectFileCards(tools);
    if (files.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: files.map((file) {
        return Material(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8.r),
          child: InkWell(
            onTap: onOpenArtifact == null
                ? null
                : () {
                    onOpenArtifact!(AiArtifact(
                      id: file.path,
                      name: file.name,
                      type: AiArtifactType.md,
                      content: '',
                      timestamp: 0,
                      path: file.path,
                    ));
                  },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 160.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFEBEEF5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined, size: 20.sp, color: const Color(0xFF636E72)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                        ),
                        Text(file.label, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF636E72))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
