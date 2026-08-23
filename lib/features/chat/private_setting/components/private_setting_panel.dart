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

import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivateSettingPanel extends StatelessWidget {
  final String nickname;
  final String userId;
  final String avatar;
  final bool isTop;
  final bool isMuted;
  final VoidCallback onToggleTop;
  final VoidCallback onToggleMute;
  final VoidCallback onClearHistory;
  final VoidCallback onDeleteConversation;

  const PrivateSettingPanel({
    super.key,
    required this.nickname,
    required this.userId,
    required this.avatar,
    required this.isTop,
    required this.isMuted,
    required this.onToggleTop,
    required this.onToggleMute,
    required this.onClearHistory,
    required this.onDeleteConversation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Row(
            children: [
              BeaverCachedImage(
                fileUrl: avatar,
                type: CacheType.avatar,
                width: 52.w,
                height: 52.w,
                borderRadius: 12.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      'ID: $userId',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '置顶聊天',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isTop,
              onChanged: (_) => onToggleTop(),
              activeColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '消息免打扰',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isMuted,
              onChanged: (_) => onToggleMute(),
              activeColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '清空聊天记录',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFF44336),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: onClearHistory,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '删除会话',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFF44336),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: onDeleteConversation,
          ),
        ),
      ],
    );
  }
}
