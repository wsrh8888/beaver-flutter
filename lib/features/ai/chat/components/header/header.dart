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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMenu;
  final VoidCallback? onArtifact;
  final bool showArtifact;

  const AiChatHeader({
    super.key,
    required this.title,
    required this.onMenu,
    this.onArtifact,
    this.showArtifact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 48.h,
        child: Row(
          children: [
            IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.menu, color: Color(0xFF2D3436)),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436)),
              ),
            ),
            if (showArtifact && onArtifact != null)
              IconButton(
                onPressed: onArtifact,
                icon: const Icon(Icons.article_outlined, color: Color(0xFF2D3436)),
              ),
          ],
        ),
      ),
    );
  }
}
