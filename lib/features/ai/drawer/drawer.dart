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

import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/ai/ai.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _DrawerTab { cloud, computer }

/// 左上角打开的侧栏。头部和底栏固定，中间按「云端工作 / 连接电脑」切换。
class AiSideDrawer extends StatefulWidget {
  final VoidCallback onPickComputer;

  const AiSideDrawer({super.key, required this.onPickComputer});

  @override
  State<AiSideDrawer> createState() => _AiSideDrawerState();
}

class _AiSideDrawerState extends State<AiSideDrawer> {
  _DrawerTab _tab = _DrawerTab.cloud;
  bool _taskOpen = true;
  bool _spaceOpen = true;
  final Set<String> _closedSpaces = {};

  @override
  void initState() {
    super.initState();
    _tab = context.read<AiStore>().state.cloudMode ? _DrawerTab.cloud : _DrawerTab.computer;
  }

  void _soon() {
    BeaverToast.show(context, '暂未开放');
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _openThread(String id) {
    context.read<AiStore>().openThread(id);
    _close();
  }

  Future<void> _useComputer() async {
    setState(() => _tab = _DrawerTab.computer);
    final store = context.read<AiStore>();
    final ok = await store.refreshRemote();
    if (!mounted) return;
    if (!ok) BeaverToast.show(context, '加载失败，请重试');
    if (store.state.computer != null) return;
    final online = store.state.desktops.where((item) => item.isOnline).toList();
    if (online.length == 1) {
      store.selectComputer(online.first);
    }
  }

  void _newTask() {
    final store = context.read<AiStore>();
    if (_tab == _DrawerTab.computer && store.state.computer == null) {
      BeaverToast.show(context, '请先选择一台在线电脑');
      return;
    }
    if (_tab == _DrawerTab.cloud) {
      store.selectComputer(null);
    }
    store.showHome();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.85;
    return Drawer(
      width: width,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: BlocConsumer<AiStore, AiStoreState>(
          listenWhen: (prev, next) => prev.cloudMode != next.cloudMode,
          listener: (_, state) {
            setState(() => _tab = state.cloudMode ? _DrawerTab.cloud : _DrawerTab.computer);
          },
          builder: (context, state) {
            return Column(
              children: [
                _Header(onSettings: _soon, onMore: _soon),
                _Tabs(
                  tab: _tab,
                  onCloud: () {
                    context.read<AiStore>().selectComputer(null);
                    setState(() => _tab = _DrawerTab.cloud);
                  },
                  onComputer: _useComputer,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    children: _tab == _DrawerTab.cloud
                        ? _cloudBody(state)
                        : _computerBody(state),
                  ),
                ),
                _Balance(onTap: _soon),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _cloudBody(AiStoreState state) {
    final tasks = state.threads.where((item) => item.workspaceId.isEmpty && !item.remote).toList();
    return [
      _ArrowRow(icon: Icons.autorenew, label: '自动化', onTap: _soon),
      _ArrowRow(icon: Icons.account_tree_outlined, label: '专家', onTap: _soon),
      _ArrowRow(icon: Icons.schema_outlined, label: '项目', onTap: _soon),
      const _DividerLine(),
      Row(
        children: [
          Text('任务', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
          const Spacer(),
          TextButton(onPressed: _soon, child: const Text('编辑')),
        ],
      ),
      _NewTaskButton(onTap: _newTask),
      if (tasks.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text('还没有云端任务', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
        ),
      ...tasks.map((item) => _TaskRow(thread: item, running: state.streamingThreadId == item.id, onTap: () => _openThread(item.id))),
    ];
  }

  List<Widget> _computerBody(AiStoreState state) {
    final computer = state.computer;
    final name = computer == null
        ? '选择电脑'
        : (computer.deviceName.isNotEmpty ? computer.deviceName : '电脑');
    final deviceId = computer?.deviceId ?? '';
    final spaces = state.spaces.where((item) => deviceId.isNotEmpty && item.deviceId == deviceId).toList();
    final spaceIds = spaces.map((item) => item.id).toSet();
    final tasks = state.threads.where((item) => spaceIds.contains(item.workspaceId)).toList();
    return [
      _DeviceChip(
        name: name,
        online: computer?.isOnline ?? false,
        onTap: () {
          _close();
          widget.onPickComputer();
        },
      ),
      _IconRow(icon: Icons.add, label: '新建任务', onTap: _newTask),
      _IconRow(icon: Icons.autorenew, label: '自动化', onTap: _soon),
      const _DividerLine(),
      _GroupHead(
        label: '任务 (${tasks.length})',
        open: _taskOpen,
        onTap: () => setState(() => _taskOpen = !_taskOpen),
      ),
      if (_taskOpen && tasks.isEmpty)
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text('还没有这台电脑上的任务', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
        ),
      if (_taskOpen)
        ...tasks.map((item) => _TaskRow(thread: item, running: state.streamingThreadId == item.id, onTap: () => _openThread(item.id))),
      const _DividerLine(),
      _GroupHead(
        label: '空间',
        open: _spaceOpen,
        onTap: () => setState(() => _spaceOpen = !_spaceOpen),
      ),
      if (_spaceOpen && deviceId.isEmpty)
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text('先选择一台在线电脑', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
        ),
      if (_spaceOpen && deviceId.isNotEmpty && spaces.isEmpty)
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text('这台电脑还没有打开过文件夹', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
        ),
      if (_spaceOpen)
        ...spaces.map((space) {
          final open = !_closedSpaces.contains(space.id);
          final children = tasks.where((item) => item.workspaceId == space.id).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() {
                  if (open) {
                    _closedSpaces.add(space.id);
                  } else {
                    _closedSpaces.remove(space.id);
                  }
                }),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_outlined, size: 18, color: Color(0xFF2D3436)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(space.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436))),
                      ),
                      Icon(open ? Icons.expand_more : Icons.chevron_right, color: const Color(0xFFB2BEC3)),
                      IconButton(
                        onPressed: () {
                          context.read<AiStore>().focusSpace(space.id);
                          _close();
                        },
                        icon: const Icon(Icons.add, size: 18, color: Color(0xFF2D3436)),
                      ),
                    ],
                  ),
                ),
              ),
              if (open && children.isEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 26.w, bottom: 8.h),
                  child: Text('还没有任务', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72))),
                ),
              if (open)
                ...children.map((item) => Padding(
                  padding: EdgeInsets.only(left: 26.w),
                  child: _TaskRow(thread: item, running: state.streamingThreadId == item.id, onTap: () => _openThread(item.id)),
                )),
              const _DividerLine(),
            ],
          );
        }),
    ];
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onMore;

  const _Header({required this.onSettings, required this.onMore});

  @override
  Widget build(BuildContext context) {
    final info = context.watch<UserStore>().getUserInfo(context.watch<ContactStore>());
    final name = (info != null && info.nickname.isNotEmpty) ? info.nickname : '海狸';
    final letter = name.isEmpty ? '海' : String.fromCharCode(name.runes.first);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
      child: Row(
        children: [
          if (info?.avatar != null && info!.avatar!.isNotEmpty)
            BeaverAvatar(avatar: info.avatar, size: 36, borderRadius: 18)
          else
            CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFFFFE6D9),
              child: Text(letter, style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF7D45))),
            ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
          ),
          IconButton(onPressed: onSettings, icon: const Icon(Icons.settings_outlined, color: Color(0xFF2D3436))),
          IconButton(onPressed: onMore, icon: const Icon(Icons.dehaze, color: Color(0xFF2D3436))),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final _DrawerTab tab;
  final VoidCallback onCloud;
  final VoidCallback onComputer;

  const _Tabs({required this.tab, required this.onCloud, required this.onComputer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _TabLabel(label: '云端工作', active: tab == _DrawerTab.cloud, onTap: onCloud),
          SizedBox(width: 16.w),
          _TabLabel(label: '连接电脑', active: tab == _DrawerTab.computer, onTap: onComputer),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabLabel({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? const Color(0xFF2D3436) : const Color(0xFF636E72),
          ),
        ),
      ),
    );
  }
}

class _DeviceChip extends StatelessWidget {
  final String name;
  final bool online;
  final VoidCallback onTap;

  const _DeviceChip({required this.name, required this.online, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: online ? const Color(0xFF22C55E) : const Color(0xFFB2BEC3), shape: BoxShape.circle),
              ),
              SizedBox(width: 6.w),
              const Icon(Icons.desktop_windows_outlined, size: 16, color: Color(0xFF2D3436)),
              SizedBox(width: 6.w),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 160.w),
                child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2D3436))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2D3436)),
            SizedBox(width: 10.w),
            Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)))),
          ],
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ArrowRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2D3436)),
            SizedBox(width: 10.w),
            Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)))),
            const Icon(Icons.chevron_right, color: Color(0xFFB2BEC3)),
          ],
        ),
      ),
    );
  }
}

class _GroupHead extends StatelessWidget {
  final String label;
  final bool open;
  final VoidCallback onTap;

  const _GroupHead({required this.label, required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF636E72)))),
            Icon(open ? Icons.expand_more : Icons.chevron_right, color: const Color(0xFFB2BEC3)),
          ],
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final AiThread thread;
  final bool running;
  final VoidCallback onTap;

  const _TaskRow({required this.thread, required this.running, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(thread.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436))),
            ),
            if (running)
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF7D45)),
              ),
          ],
        ),
      ),
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewTaskButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2D3436),
          side: const BorderSide(color: Color(0xFFEBEEF5)),
          minimumSize: Size(double.infinity, 40.h),
        ),
        child: const Text('+ 新建任务'),
      ),
    );
  }
}

class _Balance extends StatelessWidget {
  final VoidCallback onTap;

  const _Balance({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: Row(
          children: [
            const Icon(Icons.toll_outlined, size: 18, color: Color(0xFF2D3436)),
            SizedBox(width: 8.w),
            Expanded(child: Text('积分余额', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436)))),
            const Icon(Icons.chevron_right, color: Color(0xFFB2BEC3)),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 16, color: Color(0xFFEBEEF5));
  }
}
