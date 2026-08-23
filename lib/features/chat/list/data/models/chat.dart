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

class ChatModel {
  final String conversationId;
  final String nickname;
  final String? avatar;
  final String msgPreview;
  final String updateAt;
  final bool isTop;
  final int unreadCount;

  const ChatModel({
    required this.conversationId,
    required this.nickname,
    this.avatar,
    required this.msgPreview,
    required this.updateAt,
    this.isTop = false,
    this.unreadCount = 0,
  });

  ChatModel copyWith({
    String? conversationId,
    String? nickname,
    String? avatar,
    String? msgPreview,
    String? updateAt,
    bool? isTop,
    int? unreadCount,
  }) {
    return ChatModel(
      conversationId: conversationId ?? this.conversationId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      msgPreview: msgPreview ?? this.msgPreview,
      updateAt: updateAt ?? this.updateAt,
      isTop: isTop ?? this.isTop,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
