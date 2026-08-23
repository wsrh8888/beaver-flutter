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

class ContactModel {
  final String userId;
  final String nickname;
  final String? notice;
  final String? avatar;
  final String? fileName;

  const ContactModel({
    required this.userId,
    required this.nickname,
    this.notice,
    this.avatar,
    this.fileName,
  });

  ContactModel copyWith({
    String? userId,
    String? nickname,
    String? notice,
    String? avatar,
    String? fileName,
  }) {
    return ContactModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      notice: notice ?? this.notice,
      avatar: avatar ?? this.avatar,
      fileName: fileName ?? this.fileName,
    );
  }
}
