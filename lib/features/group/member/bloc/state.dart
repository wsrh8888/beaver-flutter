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

import 'package:beaver/features/group/member/data/models/member.dart';

enum GroupMemberStatus { initial, loading, success, error }

class GroupMemberState {
  final GroupMemberStatus status;
  final String mode; // 'add', 'remove', 'view'
  final String groupId;
  final List<GroupMember> groupMembers;
  final List<Contact> contacts;
  final List<String> selectedIds;
  final String? errorMessage;

  const GroupMemberState({
    this.status = GroupMemberStatus.initial,
    this.mode = 'view',
    this.groupId = '',
    this.groupMembers = const [],
    this.contacts = const [],
    this.selectedIds = const [],
    this.errorMessage,
  });

  int get selectedCount => selectedIds.length;

  GroupMemberState copyWith({
    GroupMemberStatus? status,
    String? mode,
    String? groupId,
    List<GroupMember>? groupMembers,
    List<Contact>? contacts,
    List<String>? selectedIds,
    String? errorMessage,
  }) {
    return GroupMemberState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      groupId: groupId ?? this.groupId,
      groupMembers: groupMembers ?? this.groupMembers,
      contacts: contacts ?? this.contacts,
      selectedIds: selectedIds ?? this.selectedIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

