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

enum PostMomentStatus { initial, loading, success, error }

class PostMomentState {
  final PostMomentStatus status;
  final String content;
  final List<String> mediaList;
  final String? errorMessage;

  const PostMomentState({
    this.status = PostMomentStatus.initial,
    this.content = '',
    this.mediaList = const [],
    this.errorMessage,
  });

  bool get canPost => content.trim().isNotEmpty || mediaList.isNotEmpty;

  PostMomentState copyWith({
    PostMomentStatus? status,
    String? content,
    List<String>? mediaList,
    String? errorMessage,
  }) {
    return PostMomentState(
      status: status ?? this.status,
      content: content ?? this.content,
      mediaList: mediaList ?? this.mediaList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
