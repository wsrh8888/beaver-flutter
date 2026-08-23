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
  final String nickname;
  final String fileName;
  final String? remarkName;
  final String? signature;
  final String? gender;
  final String? location;
  final String? age;
  final String? constellation;
  final String? occupation;
  final String? education;
  final String? hobbies;
  final List<String> photos;
  final String? conversationId;
  final String? source;

  const UserInfo({
    required this.userId,
    required this.nickname,
    required this.fileName,
    this.remarkName,
    this.signature,
    this.gender,
    this.location,
    this.age,
    this.constellation,
    this.occupation,
    this.education,
    this.hobbies,
    this.photos = const [],
    this.conversationId,
    this.source,
  });

  UserInfo copyWith({
    String? userId,
    String? nickname,
    String? fileName,
    String? remarkName,
    String? signature,
    String? gender,
    String? location,
    String? age,
    String? constellation,
    String? occupation,
    String? education,
    String? hobbies,
    List<String>? photos,
    String? conversationId,
    String? source,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      fileName: fileName ?? this.fileName,
      remarkName: remarkName ?? this.remarkName,
      signature: signature ?? this.signature,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      age: age ?? this.age,
      constellation: constellation ?? this.constellation,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      hobbies: hobbies ?? this.hobbies,
      photos: photos ?? this.photos,
      conversationId: conversationId ?? this.conversationId,
      source: source ?? this.source,
    );
  }
}

class InfoItem {
  final String label;
  final String value;

  const InfoItem({
    required this.label,
    required this.value,
  });
}
