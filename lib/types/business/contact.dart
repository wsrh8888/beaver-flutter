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

/// 好友仓库接口
abstract class FriendRepositoryInterface {
  Future<List<ContactModel>> getContactList();
  Map<String, List<ContactModel>> groupContactsByLetter(
    List<ContactModel> contacts,
  );
  List<String> getIndexList(Map<String, List<ContactModel>> groups);
  Future<void> deleteFriend(String friendId);

  Future<List<FriendRequest>> getFriendRequests();
  Future<int> getUnreadFriendRequestCount(String userId);
}

class FriendRequest {
  final String id;
  final String nickname;
  final String fileName;
  final String? message;
  final String source;
  final String flag; // 'receive' or 'send'
  final int status; // 0: pending, 1: accepted, 2: rejected
  final String createdAt;

  const FriendRequest({
    required this.id,
    required this.nickname,
    required this.fileName,
    this.message,
    required this.source,
    required this.flag,
    required this.status,
    required this.createdAt,
  });
}

class ContactModel extends Equatable {
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

  @override
  List<Object?> get props => [userId, nickname, notice, avatar, fileName];

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
