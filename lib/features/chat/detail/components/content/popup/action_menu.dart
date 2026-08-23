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

import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/features/chat/detail/components/content/handler/index.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageActionMenu extends StatelessWidget {
  final MessageModel message;
  const MessageActionMenu({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final handler = MessageHandlerFactory.getHandler(message.type);
    final items = handler.getMenuItems(message);

    return Container(
      width: 180.w,
      padding: EdgeInsets.symmetric(vertical: 6.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3436), // Dark Grey from AI doc
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, 8.w),
            blurRadius: 24.w,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items
            .map((action) => _buildActionItem(context, action, handler))
            .toList(),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    MessageAction action,
    BaseMessageHandler handler,
  ) {
    return _buildMenuItem(context, action.icon, action.label, () async {
      Navigator.pop(context);
      // 特殊处理跳转逻辑
      if (action.id == 'multiSelect') {
        context.read<ChatBloc>().add(
          EnterMultiSelectEvent(initialMessageId: message.id),
        );
      } else if (action.id == 'reply') {
        context.read<ChatBloc>().add(StartReplyMessageEvent(message));
      } else if (action.id == 'forward') {
        ForwardHandler.navigateToPicker(context, messageIds: [message.id]);
      } else {
        await handler.handleCommand(context, action.id, message);
      }
    }, isDestructive: action.isDestructive);
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: isDestructive ? const Color(0xFFFF5252) : Colors.white,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDestructive ? const Color(0xFFFF5252) : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showMessageActionMenu(
  BuildContext context,
  MessageModel message,
  Offset position,
) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            left: _calculateX(position.dx),
            top: _calculateY(position.dy),
            child: Material(
              color: Colors.transparent,
              child: MessageActionMenu(message: message),
            ),
          ),
        ],
      );
    },
  );
}

double _calculateX(double x) => (x + 180.w > 1.sw) ? 1.sw - 200.w : x;
double _calculateY(double y) => (y + 300.w > 1.sh) ? 1.sh - 320.w : y;
