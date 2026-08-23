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

import 'package:beaver/types/business/chat.dart';
import 'package:beaver/types/business/group.dart';
import 'package:equatable/equatable.dart';

enum GroupSettingStatus { initial, loading, success, error, deleted, historyCleared }

class GroupSettingState extends Equatable {
  final GroupSettingStatus status;
  final String conversationId;
  final ChatModel? conversation;
  final List<GroupMember> groupMembers;
  final String currentUserId;
  final bool isSaving;
  final bool showDeleteDialog;
  final bool showClearDialog;
  final String? errorMessage;

  const GroupSettingState({
    this.status = GroupSettingStatus.initial,
    this.conversationId = '',
    this.conversation,
    this.groupMembers = const [],
    this.currentUserId = '',
    this.isSaving = false,
    this.showDeleteDialog = false,
    this.showClearDialog = false,
    this.errorMessage,
  });

  GroupMember? get selfInGroup {
    if (currentUserId.isEmpty || groupMembers.isEmpty) return null;
    return groupMembers.where((m) => m.userId == currentUserId).firstOrNull;
  }

  /// role: 1=owner, 2=admin, 3=member
  bool get isGroupOwner => selfInGroup?.role == 1;

  bool get isAdmin {
    final self = selfInGroup;
    return self != null && (self.role == 1 || self.role == 2);
  }

  GroupSettingState copyWith({
    GroupSettingStatus? status,
    String? conversationId,
    ChatModel? conversation,
    List<GroupMember>? groupMembers,
    String? currentUserId,
    bool? isSaving,
    bool? showDeleteDialog,
    bool? showClearDialog,
    String? errorMessage,
  }) {
    return GroupSettingState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      groupMembers: groupMembers ?? this.groupMembers,
      currentUserId: currentUserId ?? this.currentUserId,
      isSaving: isSaving ?? this.isSaving,
      showDeleteDialog: showDeleteDialog ?? this.showDeleteDialog,
      showClearDialog: showClearDialog ?? this.showClearDialog,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversationId,
        conversation,
        groupMembers,
        currentUserId,
        isSaving,
        showDeleteDialog,
        showClearDialog,
        errorMessage,
      ];
}
