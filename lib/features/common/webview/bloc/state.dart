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

enum WebViewStatus { initial, loading, success, error }

class WebViewState extends Equatable {
  final WebViewStatus status;
  final String url;
  final double progress;
  final String? errorMessage;
  final String? pageTitle;

  const WebViewState({
    this.status = WebViewStatus.initial,
    required this.url,
    this.progress = 0,
    this.errorMessage,
    this.pageTitle,
  });

  WebViewState copyWith({
    WebViewStatus? status,
    String? url,
    double? progress,
    String? errorMessage,
    String? pageTitle,
  }) {
    return WebViewState(
      status: status ?? this.status,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      pageTitle: pageTitle ?? this.pageTitle,
    );
  }

  @override
  List<Object?> get props => [status, url, progress, errorMessage, pageTitle];
}
