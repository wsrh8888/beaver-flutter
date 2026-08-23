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
import 'package:beaver/types/business/user.dart';

enum ForwardPickerStatus { initial, loading, success, failure, executing, completed }

class ForwardPickerState extends Equatable {
  final ForwardPickerStatus status;
  final List<UserInfo> contacts;
  final String? error;

  const ForwardPickerState({
    this.status = ForwardPickerStatus.initial,
    this.contacts = const [],
    this.error,
  });

  ForwardPickerState copyWith({
    ForwardPickerStatus? status,
    List<UserInfo>? contacts,
    String? error,
  }) {
    return ForwardPickerState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, contacts, error];
}
