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

/// 表情基础模型 (对应 PC 端 IEmojiBase)
class EmojiModel extends Equatable {
  final String emojiId;
  final String name;
  final String fileKey;
  final int? version;
  final String? packageId;

  const EmojiModel({
    required this.emojiId,
    required this.name,
    required this.fileKey,
    this.version,
    this.packageId,
  });

  factory EmojiModel.fromJson(Map<String, dynamic> json) {
    return EmojiModel(
      emojiId: json['emojiId'] ?? '',
      name: json['name'] ?? '',
      fileKey: json['fileKey'] ?? json['icon'] ?? '',
      version: json['version'],
      packageId: json['packageId'],
    );
  }

  @override
  List<Object?> get props => [emojiId, name, fileKey, version, packageId];
}

/// 表情包模型 (对应 PC 端 IEmojiPackageBase)
class EmojiPackageModel extends Equatable {
  final String packageId;
  final String title;
  final String coverFile;

  const EmojiPackageModel({
    required this.packageId,
    required this.title,
    required this.coverFile,
  });

  factory EmojiPackageModel.fromJson(Map<String, dynamic> json) {
    return EmojiPackageModel(
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      coverFile: json['coverFile'] ?? '',
    );
  }

  @override
  List<Object?> get props => [packageId, title, coverFile];
}

/// 收藏表情模型 (对应 PC 端 IFavoriteEmoji)
class FavoriteEmojiModel extends Equatable {
  final String emojiId;
  final String fileKey;
  final String title;
  final String? packageId;
  final int? width;
  final int? height;

  const FavoriteEmojiModel({
    required this.emojiId,
    required this.fileKey,
    required this.title,
    this.packageId,
    this.width,
    this.height,
  });

  factory FavoriteEmojiModel.fromJson(Map<String, dynamic> json) {
    return FavoriteEmojiModel(
      emojiId: json['emojiId'] ?? '',
      fileKey: json['fileKey'] ?? '',
      title: json['title'] ?? '',
      packageId: json['packageId'],
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  List<Object?> get props => [
    emojiId,
    fileKey,
    title,
    packageId,
    width,
    height,
  ];
}
