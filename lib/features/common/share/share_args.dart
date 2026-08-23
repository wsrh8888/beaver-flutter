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

/// 实体分享入参（群 / 圈等，对齐 PC Share cardType）
class EntityShareArgs {
  /// 1=个人 2=群 3=圈子
  final int cardType;
  final String id;
  final String name;
  final String inviteUrl;
  final String? avatar;

  const EntityShareArgs({
    required this.cardType,
    required this.id,
    required this.name,
    required this.inviteUrl,
    this.avatar,
  });

  bool get isGroup => cardType == 2;
  bool get isCircle => cardType == 3;

  String get title {
    if (isGroup) return '分享群聊';
    if (isCircle) return '分享圈子';
    return '分享';
  }

  String get cardTabLabel {
    if (isGroup) return '群名片';
    if (isCircle) return '圈子名片';
    return '名片';
  }

  String get qrTabLabel {
    if (isGroup) return '群二维码';
    if (isCircle) return '圈子二维码';
    return '二维码';
  }

  String get cardHint {
    if (isGroup) return '分享后对方可一键加入群聊';
    if (isCircle) return '分享后对方可一键加入圈子';
    return '分享给好友';
  }

  String get entityLabel {
    if (isGroup) return '群聊';
    if (isCircle) return '圈子';
    return '名片';
  }
}
