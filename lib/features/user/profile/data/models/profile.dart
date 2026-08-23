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

class UserInfo {
  final String userId;
  final String nickName;
  final String fileName;
  final String email;
  final int gender; // 1: 男, 2: 女, 3: 未知
  final String? abstract;

  const UserInfo({
    required this.userId,
    required this.nickName,
    required this.fileName,
    required this.email,
    required this.gender,
    this.abstract,
  });

  UserInfo copyWith({
    String? userId,
    String? nickName,
    String? fileName,
    String? email,
    int? gender,
    String? abstract,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      fileName: fileName ?? this.fileName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      abstract: abstract ?? this.abstract,
    );
  }
}
