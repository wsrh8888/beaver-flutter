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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';

class GroupMember {
  final String userId;
  final String nickname;
  final String? avatar;
  final String role;

  GroupMember({
    required this.userId,
    required this.nickname,
    this.avatar,
    required this.role,
  });
}

class GroupMemberPage extends StatefulWidget {
  final String groupId;
  const GroupMemberPage({super.key, required this.groupId});

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '群成员',
      showBack: true,
      child: ListView.builder(
        itemCount: 1, // 模拟
        itemBuilder: (context, index) {
          return _buildMemberItem(
            GroupMember(
              userId: '1',
              nickname: '管理员',
              role: 'owner',
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemberItem(GroupMember member) {
    return ListTile(
      leading: BeaverCachedImage(
        fileUrl: member.avatar,
        type: CacheType.avatar,
        width: 40.w,
        height: 40.w,
        borderRadius: 20.w,
      ),
      title: Text(member.nickname),
      trailing: Text(
        member.role == 'owner' ? '群主' : '成员',
        style: TextStyle(fontSize: 12.w, color: Colors.grey),
      ),
    );
  }
}
