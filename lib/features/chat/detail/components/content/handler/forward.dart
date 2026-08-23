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

import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ForwardHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(BuildContext context, String commandId, MessageModel message) async {
    if (commandId == 'forward') {
      navigateToPicker(context, messageIds: [message.id]);
    }
  }

  /// 封装转发路由跳转逻辑
  static void navigateToPicker(
    BuildContext context, {
    required List<String> messageIds,
    int forwardMode = 1,
  }) {
    context.push(
      AppRoutes.chatForward,
      extra: {'messageIds': messageIds, 'forwardMode': forwardMode},
    );
  }

  @override
  List<String> getSupportedCommands() {
    return ['forward', 'multiSelect', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    return [
      BaseMessageHandler.forwardAction,
      BaseMessageHandler.multiSelectAction,
      BaseMessageHandler.deleteAction,
    ];
  }
}
