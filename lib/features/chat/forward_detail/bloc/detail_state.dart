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
import 'package:beaver/types/business/message.dart';

enum ForwardDetailStatus { initial, loading, success, failure }

class ForwardDetailState extends Equatable {
  final ForwardDetailStatus status;
  final String title;
  final List<MessageModel> messages;
  final String? error;

  const ForwardDetailState({
    this.status = ForwardDetailStatus.initial,
    this.title = '',
    this.messages = const [],
    this.error,
  });

  ForwardDetailState copyWith({
    ForwardDetailStatus? status,
    String? title,
    List<MessageModel>? messages,
    String? error,
  }) {
    return ForwardDetailState(
      status: status ?? this.status,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, title, messages, error];
}
