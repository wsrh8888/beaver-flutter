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

import 'package:equatable/equatable.dart';

abstract class GroupSettingEvent extends Equatable {
  const GroupSettingEvent();

  @override
  List<Object?> get props => [];
}

class InitGroupSettingEvent extends GroupSettingEvent {
  final String conversationId;
  const InitGroupSettingEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class TogglePinGroupChatEvent extends GroupSettingEvent {
  const TogglePinGroupChatEvent();
}

class ToggleMuteGroupChatEvent extends GroupSettingEvent {
  const ToggleMuteGroupChatEvent();
}

class DeleteGroupConversationEvent extends GroupSettingEvent {
  const DeleteGroupConversationEvent();
}

class ShowDeleteGroupDialogEvent extends GroupSettingEvent {
  final bool show;
  const ShowDeleteGroupDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}

class AddGroupMembersEvent extends GroupSettingEvent {
  final List<String> userIds;
  const AddGroupMembersEvent(this.userIds);

  @override
  List<Object?> get props => [userIds];
}

class RemoveGroupMemberEvent extends GroupSettingEvent {
  final String userId;
  const RemoveGroupMemberEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DisbandGroupEvent extends GroupSettingEvent {
  const DisbandGroupEvent();
}

class ClearGroupChatHistoryEvent extends GroupSettingEvent {
  const ClearGroupChatHistoryEvent();
}

class ShowClearGroupHistoryDialogEvent extends GroupSettingEvent {
  final bool show;
  const ShowClearGroupHistoryDialogEvent(this.show);

  @override
  List<Object?> get props => [show];
}
