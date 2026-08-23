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

/// 圈子本地展示模型（对齐 PC CircleStore）
class CircleInfo {
  final String circleId;
  final String conversationId;
  final String name;
  final String avatar;
  final String description;
  final int memberCount;
  final int role;
  final int joinType;
  final int version;

  const CircleInfo({
    required this.circleId,
    required this.conversationId,
    required this.name,
    required this.avatar,
    this.description = '',
    this.memberCount = 0,
    this.role = 0,
    this.joinType = 0,
    this.version = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircleInfo &&
        other.circleId == circleId &&
        other.conversationId == conversationId &&
        other.name == name &&
        other.avatar == avatar &&
        other.description == description &&
        other.memberCount == memberCount &&
        other.role == role &&
        other.joinType == joinType &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(
        circleId,
        conversationId,
        name,
        avatar,
        description,
        memberCount,
        role,
        joinType,
        version,
      );
}
