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

class MomentInteractionItem {
  final String eventId;
  final String eventType;
  final String fromUserId;
  final String momentId;
  final String? commentId;
  final String? content;
  final int createdAt;
  final bool isRead;

  const MomentInteractionItem({
    required this.eventId,
    required this.eventType,
    required this.fromUserId,
    required this.momentId,
    this.commentId,
    this.content,
    required this.createdAt,
    required this.isRead,
  });

  String get actionText {
    switch (eventType) {
      case 'moment_like':
        return '赞了你的朋友圈';
      case 'moment_comment':
        return '评论了你';
      case 'moment_comment_reply':
        return '回复了你';
      default:
        return '互动了你的朋友圈';
    }
  }
}
