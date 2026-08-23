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

enum CirclePostStatus { initial, loading, success, error }

class CirclePostState extends Equatable {
  final CirclePostStatus status;
  final String title;
  final String content;
  final List<String> mediaList;
  final String? errorMessage;

  const CirclePostState({
    this.status = CirclePostStatus.initial,
    this.title = '',
    this.content = '',
    this.mediaList = const [],
    this.errorMessage,
  });

  bool get canPost =>
      content.trim().isNotEmpty || mediaList.isNotEmpty;

  CirclePostState copyWith({
    CirclePostStatus? status,
    String? title,
    String? content,
    List<String>? mediaList,
    String? errorMessage,
  }) {
    return CirclePostState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaList: mediaList ?? this.mediaList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, title, content, mediaList, errorMessage];
}
