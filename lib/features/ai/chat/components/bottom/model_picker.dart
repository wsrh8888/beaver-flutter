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

import 'package:beaver/store/ai/ai.dart';
import 'package:beaver/types/api/agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 输入框旁的当前模型 chip。点击弹出底部选择器（官方 + 自定义，选中打勾）。
class AiModelChip extends StatelessWidget {
  const AiModelChip({super.key});

  Future<void> _open(BuildContext context) async {
    final store = context.read<AiStore>();
    // 先确保模型已加载，再弹出，避免首次打开是空列表。
    await store.ensureModels();
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => BlocBuilder<AiStore, AiStoreState>(
        builder: (_, state) => _AiModelSheet(store: store, state: state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = context.watch<AiStore>().selectedModelLabel;
    return Material(
      color: const Color(0xFFF2F3F7),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _open(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.psychology_outlined, size: 15.r, color: const Color(0xFF6B7280)),
              SizedBox(width: 4.w),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 140.w),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF2D3436)),
                ),
              ),
              Icon(Icons.expand_more, size: 16.r, color: const Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiModelSheet extends StatelessWidget {
  final AiStore store;
  final AiStoreState state;

  const _AiModelSheet({required this.store, required this.state});

  void _pick(BuildContext context, AgentModelItem item) {
    store.selectModel(item.source, item.modelId);
    Navigator.of(context).pop();
  }

  Widget _groupTitle(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 6.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF9AA0A6)),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, AgentModelItem item) {
    final selected = item.modelId == state.selectedModelId && item.source == state.selectedModelSource;
    return ListTile(
      title: Text(
        item.name.isNotEmpty ? item.name : item.modelId,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436)),
      ),
      subtitle: item.provider.isNotEmpty ? Text(item.provider, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF9AA0A6))) : null,
      trailing: selected ? const Icon(Icons.check, color: Color(0xFFFF7D45)) : null,
      onTap: () => _pick(context, item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final official = state.models.where((m) => m.source == 'official').toList();
    final custom = state.models.where((m) => m.source == 'custom').toList();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 4.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '选择模型',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436)),
                  ),
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          if (state.models.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Center(
                child: Text('暂无可用模型', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF9AA0A6))),
              ),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (official.isNotEmpty) ...[
                  _groupTitle('官方模型'),
                  ...official.map((m) => _tile(context, m)),
                ],
                if (custom.isNotEmpty) ...[
                  _groupTitle('自定义模型'),
                  ...custom.map((m) => _tile(context, m)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
