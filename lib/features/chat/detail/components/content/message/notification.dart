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

import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationMessage extends StatelessWidget {
  final MessageModel message;
  const NotificationMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactStore, ContactStoreState>(
      builder: (context, contactState) {
        return BlocBuilder<GroupMemberStore, GroupMemberStoreState>(
          builder: (context, groupMemberState) {
            final text = _getNotificationText(context);
            return Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 32.w),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F6), // 浅灰色背景，类似微信
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFB2BEC3), // 灰色文字
                    height: 1.4,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getNotificationText(BuildContext context) {
    final notificationMsg = message.msg.notificationMsg;
    if (notificationMsg == null) {
      return message.content.isNotEmpty ? message.content : '[通知消息]';
    }

    final type = notificationMsg.type;
    final actors = notificationMsg.actors;

    if (actors.isEmpty) {
      return '[通知消息]';
    }

    final contactStore = context.read<ContactStore>();

    final actorNames = actors.map((userId) {
      // 从联系人获取 (包含了所有本地已知的用户信息)
      final contact = contactStore.getContact(userId);
      if (contact != null) {
        return contact.nickname;
      }

      return userId;
    }).toList();

    final names = actorNames.join('、');

    switch (type) {
      case 1: // 好友欢迎
        return '$names 成为了好友';
      case 2: // 创建群
        return '$names 创建了群聊';
      case 3: // 加入群
        return '$names 加入了群聊';
      case 4: // 退出群
        return '$names 退出了群聊';
      case 5: // 踢出成员
        return '$names 被移出群聊';
      case 6: // 转让群主
        return '群主已转让给 $names';
      default:
        return '[通知消息]';
    }
  }
}
