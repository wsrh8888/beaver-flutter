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

enum CircleFeedStatus { initial, loading, success, error }

class CircleFeedState extends Equatable {
  final CircleFeedStatus status;
  final List<ICirclePostItem> posts;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  const CircleFeedState({
    this.status = CircleFeedStatus.initial,
    this.posts = const [],
    this.page = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  CircleFeedState copyWith({
    CircleFeedStatus? status,
    List<ICirclePostItem>? posts,
    int? page,
    bool? hasMore,
    String? errorMessage,
  }) {
    return CircleFeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, page, hasMore, errorMessage];
}
