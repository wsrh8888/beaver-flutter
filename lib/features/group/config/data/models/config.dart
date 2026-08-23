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

class GroupInfo {
  final String groupId;
  final String title;
  final String fileName;
  final int memberCount;

  const GroupInfo({
    required this.groupId,
    required this.title,
    required this.fileName,
    required this.memberCount,
  });
}

class GroupMember {
  final String userId;
  final String nickname;
  final String fileName;
  final int role; // 0: 普通成员, 1: 管理员, 2: 群主

  const GroupMember({
    required this.userId,
    required this.nickname,
    required this.fileName,
    required this.role,
  });
}
