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

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final UserInfo? userInfo;
  final Map<String, bool> modals;
  final Map<String, dynamic> formData;
  final int countdown;
  final bool isCodeSending;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userInfo,
    this.modals = const {
      'nickname': false,
      'email': false,
      'description': false,
      'gender': false,
    },
    this.formData = const {},
    this.countdown = 0,
    this.isCodeSending = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserInfo? userInfo,
    Map<String, bool>? modals,
    Map<String, dynamic>? formData,
    int? countdown,
    bool? isCodeSending,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      modals: modals ?? this.modals,
      formData: formData ?? this.formData,
      countdown: countdown ?? this.countdown,
      isCodeSending: isCodeSending ?? this.isCodeSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
