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

class MomentFile {
  final String fileName;

  const MomentFile(this.fileName);
}

class MomentLike {
  final String userId;
  final String userName;

  const MomentLike(this.userId, this.userName);
}

class Moment {
  final String id;
  final String userName;
  final String fileName;
  final String content;
  final List<MomentFile> files;
  final List<MomentLike> likes;
  final String createdAt;

  const Moment({
    required this.id,
    required this.userName,
    required this.fileName,
    required this.content,
    required this.files,
    required this.likes,
    required this.createdAt,
  });

  Moment copyWith({
    String? id,
    String? userName,
    String? fileName,
    String? content,
    List<MomentFile>? files,
    List<MomentLike>? likes,
    String? createdAt,
  }) {
    return Moment(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fileName: fileName ?? this.fileName,
      content: content ?? this.content,
      files: files ?? this.files,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
