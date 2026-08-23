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
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiSelectAction extends StatelessWidget {
  const MultiSelectAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final selectedCount = state.selectedMessageIds.length;
        final hasSelection = selectedCount > 0;

        return Container(
          height: 64.w + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.forward,
                '逐条转发',
                hasSelection,
                () {
                  ForwardHandler.navigateToPicker(
                    context,
                    messageIds: state.selectedMessageIds.toList(),
                    forwardMode: 1,
                  );
                  context.read<ChatBloc>().add(const CancelMultiSelectEvent());
                },
              ),
              _buildActionButton(
                context,
                Icons.layers_outlined,
                '合并转发',
                hasSelection,
                () {
                  ForwardHandler.navigateToPicker(
                    context,
                    messageIds: state.selectedMessageIds.toList(),
                    forwardMode: 2,
                  );
                  context.read<ChatBloc>().add(const CancelMultiSelectEvent());
                },
              ),
              _buildActionButton(
                context,
                Icons.delete_outline,
                '删除',
                hasSelection,
                () => _confirmDelete(context, selectedCount),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int count) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BeaverDialog(
        title: '删除消息',
        contentText: '确定删除选中的 $count 条消息吗？仅对自己生效。',
        confirmText: '删除',
        confirmColor: const Color(0xFFF44336),
        cancelText: '取消',
        onCancel: () => Navigator.of(dialogContext).pop(),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ChatBloc>().add(const DeleteSelectedMessagesEvent());
        },
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    bool enabled,
    VoidCallback onTap,
  ) {
    final color = enabled ? const Color(0xFF2D3436) : const Color(0xFFB2BEC3);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.w, color: color),
          SizedBox(height: 4.w),
          Text(label, style: TextStyle(fontSize: 10.sp, color: color)),
        ],
      ),
    );
  }
}
