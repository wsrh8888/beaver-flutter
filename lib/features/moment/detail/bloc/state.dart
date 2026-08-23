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
import 'package:beaver/features/moment/detail/bloc/event.dart';

class MomentDetailState {
  final MomentDetailStatus status;
  final IMomentListItem? moment;
  final String? errorMessage;
  final MomentDetailTab activeTab;
  final IMomentCommentModel? replyTarget;
  final int commentPage;
  final bool hasMoreComments;
  final bool isLoadingComments;
  final Map<String, int> childPageMap;

  const MomentDetailState({
    this.status = MomentDetailStatus.initial,
    this.moment,
    this.errorMessage,
    this.activeTab = MomentDetailTab.comments,
    this.replyTarget,
    this.commentPage = 1,
    this.hasMoreComments = false,
    this.isLoadingComments = false,
    this.childPageMap = const {},
  });

  MomentDetailState copyWith({
    MomentDetailStatus? status,
    IMomentListItem? moment,
    String? errorMessage,
    MomentDetailTab? activeTab,
    IMomentCommentModel? replyTarget,
    bool clearReplyTarget = false,
    int? commentPage,
    bool? hasMoreComments,
    bool? isLoadingComments,
    Map<String, int>? childPageMap,
  }) {
    return MomentDetailState(
      status: status ?? this.status,
      moment: moment ?? this.moment,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
      replyTarget: clearReplyTarget ? null : (replyTarget ?? this.replyTarget),
      commentPage: commentPage ?? this.commentPage,
      hasMoreComments: hasMoreComments ?? this.hasMoreComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      childPageMap: childPageMap ?? this.childPageMap,
    );
  }
}
