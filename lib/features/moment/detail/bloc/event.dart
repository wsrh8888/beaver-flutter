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

import 'package:beaver/types/api/moment.dart';

enum MomentDetailStatus { initial, loading, success, error }

enum MomentDetailTab { comments, likes }

abstract class MomentDetailEvent {
  const MomentDetailEvent();
}

class LoadMomentDetailEvent extends MomentDetailEvent {
  final String momentId;
  const LoadMomentDetailEvent(this.momentId);
}

class RefreshMomentDetailEvent extends MomentDetailEvent {
  const RefreshMomentDetailEvent();
}

class LoadMoreCommentsEvent extends MomentDetailEvent {
  const LoadMoreCommentsEvent();
}

class LoadChildCommentsEvent extends MomentDetailEvent {
  final IMomentCommentModel rootComment;
  const LoadChildCommentsEvent(this.rootComment);
}

class AddCommentEvent extends MomentDetailEvent {
  final String content;
  final IMomentCommentModel? targetComment;

  const AddCommentEvent(this.content, {this.targetComment});
}

class ToggleLikeEvent extends MomentDetailEvent {
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatar;

  const ToggleLikeEvent({
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar = '',
  });
}

class SetReplyTargetEvent extends MomentDetailEvent {
  final IMomentCommentModel? target;
  const SetReplyTargetEvent(this.target);
}

class SwitchTabEvent extends MomentDetailEvent {
  final MomentDetailTab tab;
  const SwitchTabEvent(this.tab);
}
