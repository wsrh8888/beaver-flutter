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

import 'package:beaver/features/ai/chat/chat.dart';
import 'package:beaver/features/ai/chat/components/bottom/composer.dart';
import 'package:beaver/features/ai/drawer/drawer.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/ai/ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _tags = ['写周报', '深度研究', '整理文档', '总结今天'];

/// 对齐 WorkBuddy 小程序主页：云上 / 连接电脑、欢迎语、快捷标签、底部输入。
class AiHomePage extends StatefulWidget {
  const AiHomePage({super.key});

  @override
  State<AiHomePage> createState() => _AiHomePageState();
}

class _AiHomePageState extends State<AiHomePage> {
  final _input = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    final store = context.read<AiStore>();
    store.refreshRemote().then((ok) {
      if (!ok && mounted) BeaverToast.show(context, '加载失败，请重试');
    });
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final store = context.read<AiStore>();
    final threadId = await store.startTask(text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (threadId == null) return;
    _input.clear();
  }

  Future<void> _pickComputer() async {
    final store = context.read<AiStore>();
    final listed = await store.loadDesktops();
    if (!mounted) return;
    if (!listed) BeaverToast.show(context, '加载失败，请重试');
    final computers = store.state.desktops;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('选择执行环境', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
                SizedBox(height: 12.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('云上'),
                  subtitle: const Text('普通会话，不控制电脑'),
                  trailing: store.state.cloudMode ? const Icon(Icons.check, color: Color(0xFFFF7D45)) : null,
                  onTap: () {
                    store.selectComputer(null);
                    Navigator.pop(sheetContext);
                  },
                ),
                if (computers.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text('没有在线的电脑。请先在电脑上登录海狸。', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
                  ),
                ...computers.map((device) {
                  final selected = store.state.computer?.deviceId == device.deviceId;
                  final name = device.deviceName.isNotEmpty ? device.deviceName : device.deviceModel;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(name.isNotEmpty ? name : '电脑'),
                    subtitle: Text(device.isOnline ? '在线' : '离线'),
                    enabled: device.isOnline,
                    trailing: selected ? const Icon(Icons.check, color: Color(0xFFFF7D45)) : null,
                    onTap: device.isOnline
                        ? () {
                            store.selectComputer(device);
                            Navigator.pop(sheetContext);
                          }
                        : null,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiStore, AiStoreState>(
      builder: (context, state) {
        final computerName = state.computer == null
            ? '云上'
            : (state.computer!.deviceName.isNotEmpty ? state.computer!.deviceName : '已连接电脑');
        return Scaffold(
          key: _scaffold,
          backgroundColor: const Color(0xFFF7F8FA),
          onDrawerChanged: (opened) {
            if (!opened) return;
            context.read<AiStore>().refreshRemote().then((ok) {
              if (!ok && mounted) BeaverToast.show(context, '加载失败，请重试');
            });
          },
          drawer: AiSideDrawer(onPickComputer: _pickComputer),
          body: SafeArea(
            child: state.activeThreadId.isNotEmpty
                ? AiChatPage(key: ValueKey(state.activeThreadId), threadId: state.activeThreadId)
                : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 8.h, 16.w, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _scaffold.currentState?.openDrawer(),
                        icon: const Icon(Icons.menu, color: Color(0xFF2D3436)),
                      ),
                      Text('海狸', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
                      const Spacer(),
                      _EnvChip(label: computerName, onTap: _pickComputer),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 12.h),
                    children: [
                      Text('海狸，我帮你', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
                      SizedBox(height: 8.h),
                      Text(
                        state.cloudMode ? '当前是普通会话，不控制电脑' : '指令会在 $computerName 上执行',
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72)),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 36.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tags.length,
                          separatorBuilder: (context, index) => SizedBox(width: 8.w),
                          itemBuilder: (_, index) {
                            return ActionChip(
                              label: Text(_tags[index]),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFEBEEF5)),
                              onPressed: () => _send(_tags[index]),
                            );
                          },
                        ),
                      ),
                      if (state.threads.isNotEmpty) ...[
                        SizedBox(height: 28.h),
                        Text('最近任务', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
                        SizedBox(height: 8.h),
                        ...state.threads.map((thread) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(thread.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(thread.messages.isEmpty ? '' : thread.messages.last.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                            onTap: () => context.read<AiStore>().openThread(thread.id),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                AiComposer(
                  controller: _input,
                  sending: _sending || state.streamingThreadId.isNotEmpty,
                  hint: state.cloudMode ? '发消息，或按住说' : '给这台电脑下指令',
                  onSend: () => _send(),
                  compact: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EnvChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _EnvChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Text(label, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2D3436))),
      ),
    );
  }
}

