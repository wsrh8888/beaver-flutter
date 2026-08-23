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
import 'package:beaver/types/api/circle.dart';

abstract class CircleDetailEvent extends Equatable {
  const CircleDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCircleDetailEvent extends CircleDetailEvent {
  final String postId;

  const LoadCircleDetailEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class RefreshCircleDetailEvent extends CircleDetailEvent {
  const RefreshCircleDetailEvent();
}

class LoadMoreCircleCommentsEvent extends CircleDetailEvent {
  const LoadMoreCircleCommentsEvent();
}

class LoadChildCircleCommentsEvent extends CircleDetailEvent {
  final ICircleCommentItem rootComment;

  const LoadChildCircleCommentsEvent(this.rootComment);

  @override
  List<Object?> get props => [rootComment.commentId];
}

class AddCircleCommentEvent extends CircleDetailEvent {
  final String content;
  final ICircleCommentItem? targetComment;

  const AddCircleCommentEvent({
    required this.content,
    this.targetComment,
  });

  @override
  List<Object?> get props => [content, targetComment?.commentId];
}

class ToggleCircleDetailLikeEvent extends CircleDetailEvent {
  const ToggleCircleDetailLikeEvent();
}

class SetCircleReplyTargetEvent extends CircleDetailEvent {
  final ICircleCommentItem? target;

  const SetCircleReplyTargetEvent(this.target);

  @override
  List<Object?> get props => [target?.commentId];
}
