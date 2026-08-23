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

import 'package:beaver/api/group.dart';
import 'package:beaver/features/chat/group_setting/bloc/bloc.dart';
import 'package:beaver/features/chat/group_setting/bloc/event.dart';
import 'package:beaver/features/chat/group_setting/bloc/state.dart';
import 'package:beaver/features/chat/group_setting/components/group_setting_panel.dart';
import 'package:beaver/features/common/select_friend/open_select_friend.dart';
import 'package:beaver/features/common/share/open_share.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/store/contact/contact.dart';

class GroupSettingPage extends StatelessWidget {
  final String? conversationId;

  const GroupSettingPage({super.key, this.conversationId});

  @override
  Widget build(BuildContext context) {
    if (conversationId == null || conversationId!.isEmpty) {
      return const BeaverLayout(
        title: '群聊设置',
        showBack: true,
        child: Center(child: Text('会话不存在')),
      );
    }

    return BlocProvider(
      create: (context) =>
          GroupSettingBloc()..add(InitGroupSettingEvent(conversationId!)),
      child: const _GroupSettingView(),
    );
  }
}

class _GroupSettingView extends StatelessWidget {
  const _GroupSettingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupSettingBloc, GroupSettingState>(
      listener: (context, state) {
        if (state.status == GroupSettingStatus.deleted) {
          BeaverToast.show(
            context,
            state.isGroupOwner ? '已解散群聊' : '已退出群聊',
          );
          Navigator.of(context).popUntil(
            (route) => route.settings.name == '/chat/list' || route.isFirst,
          );
        }
        if (state.status == GroupSettingStatus.historyCleared) {
          BeaverToast.show(context, '已清空聊天记录');
        }
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          BeaverToast.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: '群聊设置',
          showBack: true,
          isScrollable: true,
          overlay: _buildOverlay(context, state),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget? _buildOverlay(BuildContext context, GroupSettingState state) {
    if (!state.showDeleteDialog &&
        !state.showClearDialog &&
        !state.isSaving) {
      return null;
    }

    return Stack(
      children: [
        if (state.showDeleteDialog)
          BeaverDialog(
            title: state.isGroupOwner ? '解散群聊' : '退出群聊',
            contentText: state.isGroupOwner
                ? '确定解散该群聊吗？此操作不可撤销。'
                : '确定退出该群聊吗？',
            confirmText: '确定',
            confirmColor: const Color(0xFFF44336),
            cancelText: '取消',
            maskClosable: false,
            onCancel: () => context.read<GroupSettingBloc>().add(
                  const ShowDeleteGroupDialogEvent(false),
                ),
            onConfirm: () {
              if (state.isGroupOwner) {
                context.read<GroupSettingBloc>().add(
                      const DisbandGroupEvent(),
                    );
              } else {
                context.read<GroupSettingBloc>().add(
                      const DeleteGroupConversationEvent(),
                    );
              }
            },
          ),
        if (state.showClearDialog)
          BeaverDialog(
            title: '清空聊天记录',
            contentText: '确定清空该群聊的聊天记录吗？',
            confirmText: '清空',
            confirmColor: const Color(0xFFF44336),
            cancelText: '取消',
            maskClosable: false,
            onCancel: () => context.read<GroupSettingBloc>().add(
                  const ShowClearGroupHistoryDialogEvent(false),
                ),
            onConfirm: () => context.read<GroupSettingBloc>().add(
                  const ClearGroupChatHistoryEvent(),
                ),
          ),
        if (state.isSaving)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, GroupSettingState state) {
    if (state.status == GroupSettingStatus.loading) {
      return SizedBox(
        height: 400.w,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == GroupSettingStatus.error) {
      return SizedBox(
        height: 400.w,
        child: Center(child: Text(state.errorMessage ?? '加载失败')),
      );
    }
    if (state.conversation == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
      child: _buildPanel(context, state),
    );
  }

  Widget _buildPanel(BuildContext context, GroupSettingState state) {
    final groupStore = context.watch<GroupStore>();
    final contactStore = context.watch<ContactStore>();
    final memberStore = context.watch<GroupMemberStore>();

    final groupInfo = groupStore.getGroup(state.conversationId);
    final groupName = groupInfo?.title ?? state.conversation?.nickname ?? '群聊';
    final groupAvatar = groupInfo?.avatar ?? state.conversation?.avatar ?? '';

    final groupId = state.conversationId.replaceFirst('group_', '');
    final members = memberStore.getMembersByGroupId(groupId);

    final selfInGroup =
        members.where((m) => m.userId == state.currentUserId).firstOrNull;
    final isActualAdmin = selfInGroup != null &&
        (selfInGroup.role == 1 || selfInGroup.role == 2);
    final isGroupOwner = selfInGroup?.role == 1;

    return GroupSettingPanel(
      title: groupName,
      groupId: groupId,
      memberCount: members.length,
      avatar: groupAvatar,
      isTop: state.conversation?.isTop ?? false,
      isMuted: state.conversation?.isMuted ?? false,
      members: members,
      isAdmin: isActualAdmin,
      isGroupOwner: isGroupOwner,
      contactStore: contactStore,
      onToggleTop: () =>
          context.read<GroupSettingBloc>().add(const TogglePinGroupChatEvent()),
      onToggleMute: () =>
          context.read<GroupSettingBloc>().add(const ToggleMuteGroupChatEvent()),
      onClearHistory: () => context.read<GroupSettingBloc>().add(
            const ShowClearGroupHistoryDialogEvent(true),
          ),
      onDeleteConversation: () => context.read<GroupSettingBloc>().add(
            const ShowDeleteGroupDialogEvent(true),
          ),
      onShare: () => _shareGroup(
            context,
            groupId: groupId,
            groupName: groupName,
            avatar: groupInfo?.avatar,
          ),
      onAddMember: () async {
        final result = await openSelectFriend(
          context,
          title: '添加群成员',
          disabledUserIds: members.map((m) => m.userId).toList(),
        );

        if (result != null && result.isNotEmpty) {
          final userIds = result.map((c) => c.userId).toList();
          if (context.mounted) {
            context.read<GroupSettingBloc>().add(AddGroupMembersEvent(userIds));
          }
        }
      },
      onRemoveMember: (userId) {
        context.read<GroupSettingBloc>().add(RemoveGroupMemberEvent(userId));
      },
    );
  }
}

Future<void> _shareGroup(
  BuildContext context, {
  required String groupId,
  required String groupName,
  String? avatar,
}) async {
  final res = await getGroupInfoApi(IGroupInfoReq(groupId: groupId));
  if (!context.mounted) return;
  if (res.code != 0 || res.result == null) {
    BeaverToast.show(
      context,
      res.msg.isNotEmpty ? res.msg : '获取邀请链接失败',
    );
    return;
  }
  final inviteUrl = res.result!.inviteUrl.trim();
  if (inviteUrl.isEmpty) {
    BeaverToast.show(context, '暂无可用邀请链接');
    return;
  }
  await openGroupShare(
    context,
    groupId: groupId,
    groupName: groupName.isNotEmpty ? groupName : res.result!.title,
    inviteUrl: inviteUrl,
    avatar: avatar ?? res.result!.avatar,
  );
}
