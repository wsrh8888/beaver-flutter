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

abstract class DetailEvent {
  const DetailEvent();
}

class LoadUserInfoEvent extends DetailEvent {
  final String userId;

  const LoadUserInfoEvent(this.userId);
}

class ToggleMoreMenuEvent extends DetailEvent {
  const ToggleMoreMenuEvent();
}

class ShowEditNoteDialogEvent extends DetailEvent {
  const ShowEditNoteDialogEvent();
}

class CloseEditNoteDialogEvent extends DetailEvent {
  const CloseEditNoteDialogEvent();
}

class SaveRemarkNameEvent extends DetailEvent {
  final String remarkName;

  const SaveRemarkNameEvent(this.remarkName);
}

class DeleteFriendEvent extends DetailEvent {
  const DeleteFriendEvent();
}

class SendMessageEvent extends DetailEvent {
  const SendMessageEvent();
}

class ClearNavigationEvent extends DetailEvent {
  const ClearNavigationEvent();
}

class AudioCallEvent extends DetailEvent {
  const AudioCallEvent();
}

class VideoCallEvent extends DetailEvent {
  const VideoCallEvent();
}
