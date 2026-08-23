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

import 'package:beaver/features/contact/detail/data/models/user_info.dart';

enum DetailStatus { initial, loading, success, error }

class DetailState {
  final DetailStatus status;
  final UserInfo? userInfo;
  final bool isFriend;
  final String? newRemarkName;
  final bool showEditNoteDialog;
  final bool showMoreMenu;
  final String? errorMessage;
  final bool navigateToChat;
  final String? conversationIdForChat;

  const DetailState({
    this.status = DetailStatus.initial,
    this.userInfo,
    this.isFriend = false,
    this.newRemarkName,
    this.showEditNoteDialog = false,
    this.showMoreMenu = false,
    this.errorMessage,
    this.navigateToChat = false,
    this.conversationIdForChat,
  });

  DetailState copyWith({
    DetailStatus? status,
    UserInfo? userInfo,
    bool? isFriend,
    String? newRemarkName,
    bool? showEditNoteDialog,
    bool? showMoreMenu,
    String? errorMessage,
    bool? navigateToChat,
    String? conversationIdForChat,
  }) {
    return DetailState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      isFriend: isFriend ?? this.isFriend,
      newRemarkName: newRemarkName ?? this.newRemarkName,
      showEditNoteDialog: showEditNoteDialog ?? this.showEditNoteDialog,
      showMoreMenu: showMoreMenu ?? this.showMoreMenu,
      errorMessage: errorMessage ?? this.errorMessage,
      navigateToChat: navigateToChat ?? this.navigateToChat,
      conversationIdForChat: conversationIdForChat ?? this.conversationIdForChat,
    );
  }
}

