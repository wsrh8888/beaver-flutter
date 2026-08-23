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
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/business/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'bloc/picker_bloc.dart';
import 'bloc/picker_event.dart';
import 'bloc/picker_state.dart';

class ForwardPickerPage extends StatelessWidget {
  final List<String> messageIds;
  final int forwardMode; // 1:逐条 2:合并

  const ForwardPickerPage({
    super.key,
    this.messageIds = const [],
    this.forwardMode = 1,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForwardPickerBloc(
        messageIds: messageIds,
        forwardMode: forwardMode,
        contactStore: context.read<ContactStore>(),
      ),
      child: BlocConsumer<ForwardPickerBloc, ForwardPickerState>(
        listener: (context, state) {
          if (state.status == ForwardPickerStatus.completed) {
            BeaverToast.show(context, '转发成功');
            context.pop();
          } else if (state.status == ForwardPickerStatus.failure) {
            BeaverToast.show(context, state.error ?? '转发失败');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: forwardMode == 2 ? '合并转发' : '逐条转发',
            showBack: true,
            child: Column(
              children: [
                _buildSearchBox(context),
                Expanded(child: _buildContactList(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) => Container(
        padding: EdgeInsets.all(12.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F6),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 20.w, color: const Color(0xFF99A3AD)),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  onChanged: (val) => context
                      .read<ForwardPickerBloc>()
                      .add(LoadContactsEvent(query: val)),
                  decoration: const InputDecoration(
                    hintText: '搜索联系人',
                    hintStyle: TextStyle(color: Color(0xFF99A3AD)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildContactList(BuildContext context, ForwardPickerState state) {
    if (state.status == ForwardPickerStatus.loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7D45)));
    }
    
    final contacts = state.contacts;
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) =>
          _buildContactItem(context, contacts[index]),
    );
  }

  Widget _buildContactItem(BuildContext context, UserInfo user) {
    return InkWell(
      onTap: () {
        context.read<ForwardPickerBloc>().add(
              ExecuteForwardEvent(targetId: user.userId, forwardType: 1),
            );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w),
          ),
        ),
        child: Row(
          children: [
            BeaverAvatar(avatar: user.avatar, size: 40),
            SizedBox(width: 12.w),
            Text(
              user.nickname,
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3436)),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 22.w, color: const Color(0xFFCBD2DA)),
          ],
        ),
      ),
    );
  }
}


