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

import 'package:beaver/types/business/user.dart';

enum MineStatus { initial, loading, success, error }

class MineState {
  final MineStatus status;
  final UserInfo userInfo;
  final String? errorMessage;

  const MineState({
    this.status = MineStatus.initial,
    this.userInfo = const UserInfo(userId: '', nickname: 'Beaver'),
    this.errorMessage,
  });

  MineState copyWith({
    MineStatus? status,
    UserInfo? userInfo,
    String? errorMessage,
  }) {
    return MineState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
