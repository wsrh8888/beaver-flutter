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

import 'package:beaver/features/common/share/share_args.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/invite/invite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 打开统一实体分享全屏页（群 / 圈共用）
Future<void> openEntityShare(
  BuildContext context, {
  required int cardType,
  required String id,
  required String name,
  required String inviteUrl,
  String? avatar,
}) {
  final link = inviteUrl.trim();
  final code = parseInviteCode(link) ?? '';

  if (cardType == 2 || cardType == 3) {
    if (link.isEmpty || code.isEmpty) {
      BeaverToast.show(context, '暂无可用邀请链接');
      return Future.value();
    }
  }

  return context.push<void>(
    AppRoutes.entityShare,
    extra: EntityShareArgs(
      cardType: cardType,
      id: id,
      name: name,
      inviteUrl: link,
      avatar: avatar,
    ),
  );
}

Future<void> openGroupShare(
  BuildContext context, {
  required String groupId,
  required String groupName,
  required String inviteUrl,
  String? avatar,
}) {
  return openEntityShare(
    context,
    cardType: 2,
    id: groupId,
    name: groupName,
    inviteUrl: inviteUrl,
    avatar: avatar,
  );
}

Future<void> openCircleShare(
  BuildContext context, {
  required String circleId,
  required String circleName,
  required String inviteUrl,
  String? avatar,
}) {
  return openEntityShare(
    context,
    cardType: 3,
    id: circleId,
    name: circleName,
    inviteUrl: inviteUrl,
    avatar: avatar,
  );
}
