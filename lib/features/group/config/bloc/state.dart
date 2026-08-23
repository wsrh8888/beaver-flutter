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

import 'package:beaver/features/group/config/data/models/config.dart';

enum GroupConfigStatus { initial, loading, success, error }

class GroupConfigState {
  final GroupConfigStatus status;
  final String groupId;
  final GroupInfo? groupInfo;
  final List<GroupMember> groupMembers;
  final bool isAdmin;
  final bool showNameModal;
  final String groupName;
  final String? errorMessage;

  const GroupConfigState({
    this.status = GroupConfigStatus.initial,
    this.groupId = '',
    this.groupInfo,
    this.groupMembers = const [],
    this.isAdmin = false,
    this.showNameModal = false,
    this.groupName = '',
    this.errorMessage,
  });

  GroupConfigState copyWith({
    GroupConfigStatus? status,
    String? groupId,
    GroupInfo? groupInfo,
    List<GroupMember>? groupMembers,
    bool? isAdmin,
    bool? showNameModal,
    String? groupName,
    String? errorMessage,
  }) {
    return GroupConfigState(
      status: status ?? this.status,
      groupId: groupId ?? this.groupId,
      groupInfo: groupInfo ?? this.groupInfo,
      groupMembers: groupMembers ?? this.groupMembers,
      isAdmin: isAdmin ?? this.isAdmin,
      showNameModal: showNameModal ?? this.showNameModal,
      groupName: groupName ?? this.groupName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

