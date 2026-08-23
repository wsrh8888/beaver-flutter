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

import 'package:beaver/features/user/config/data/models/config.dart';

enum UserConfigStatus { initial, loading, success, error }

class UserConfigState {
  final UserConfigStatus status;
  final String conversationId;
  final FriendInfo? friendInfo;
  final bool isTopChat;
  final bool showDeleteModal;
  final String? errorMessage;

  const UserConfigState({
    this.status = UserConfigStatus.initial,
    this.conversationId = '',
    this.friendInfo,
    this.isTopChat = false,
    this.showDeleteModal = false,
    this.errorMessage,
  });

  UserConfigState copyWith({
    UserConfigStatus? status,
    String? conversationId,
    FriendInfo? friendInfo,
    bool? isTopChat,
    bool? showDeleteModal,
    String? errorMessage,
  }) {
    return UserConfigState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      friendInfo: friendInfo ?? this.friendInfo,
      isTopChat: isTopChat ?? this.isTopChat,
      showDeleteModal: showDeleteModal ?? this.showDeleteModal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

