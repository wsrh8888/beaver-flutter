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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/call/call_list.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/types/business/chat.dart';

class IncomingCallBanner extends StatelessWidget {
  const IncomingCallBanner({super.key});

  String _displayName(CallListItem call, List<ChatModel> conversations) {
    if (call.callType == 'group') {
      for (final conv in conversations) {
        if (conv.conversationId == call.conversationId &&
            conv.nickname.isNotEmpty) {
          return conv.nickname;
        }
      }
      return '群组通话';
    }
    return call.callerName ?? '未知用户';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallListStore, CallListStoreState>(
      builder: (context, callState) {
        final displayCalls = [
          ...callState.incomingCalls,
          ...callState.activeCalls,
        ];
        if (displayCalls.isEmpty) return const SizedBox.shrink();

        return BlocBuilder<ChatStore, ChatStoreState>(
          builder: (context, chatState) {
            return Column(
              children: displayCalls.map((call) {
                return Material(
                  color: const Color(0xFFE8F5E9),
                  child: InkWell(
                    onTap: () {
                      context.push(
                        AppRoutes.callIncoming,
                        extra: {
                          'conversationId': call.conversationId,
                          'roomId': call.roomId,
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.w,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFC8E6C9)),
                        ),
                      ),
                      child: Text(
                        '${_displayName(call, chatState.conversations)} 正在通话中',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
