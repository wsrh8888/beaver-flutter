import 'package:beaver/features/chat/group_setting/bloc/bloc.dart';
import 'package:beaver/features/chat/group_setting/bloc/event.dart';
import 'package:beaver/features/chat/group_setting/bloc/state.dart';
import 'package:beaver/features/chat/group_setting/components/group_setting_panel.dart';
import 'package:beaver/features/contact/selector/contact_selector_page.dart';
import 'package:beaver/types/business/contact.dart';
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
          BeaverToast.show(context, '已移动/删除会话');
          // Pop until chat list
          Navigator.of(context).popUntil(
            (route) => route.settings.name == '/chat/list' || route.isFirst,
          );
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
          child: Stack(
            children: [
              if (state.status == GroupSettingStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (state.status == GroupSettingStatus.error)
                Center(child: Text(state.errorMessage ?? '加载失败'))
              else if (state.conversation != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
                  child: _buildPanel(context, state),
                ),
              if (state.showDeleteDialog)
                BeaverDialog(
                  title: state.isAdmin ? '解散群聊' : '退出群聊',
                  contentText: state.isAdmin
                      ? '确定解散该群聊吗？此操作不可撤销。'
                      : '确定退出该群聊吗？',
                  confirmText: '确定',
                  cancelText: '取消',
                  onCancel: () => context.read<GroupSettingBloc>().add(
                    const ShowDeleteGroupDialogEvent(false),
                  ),
                  onConfirm: () {
                    if (state.isAdmin) {
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
              if (state.isSaving)
                Container(
                  color: Colors.black12,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, GroupSettingState state) {
    // 监听全局 Store 以获取最新资料 (对标 PC Pinia 响应式)
    final groupStore = context.watch<GroupStore>();
    final contactStore = context.watch<ContactStore>();
    final memberStore = context.watch<GroupMemberStore>();
    
    // 获取最新的群组信息
    final groupInfo = groupStore.getGroup(state.conversationId);
    final groupName = groupInfo?.title ?? state.conversation?.nickname ?? '群聊';
    final groupAvatar = groupInfo?.avatar ?? state.conversation?.avatar ?? '';

    // 获取最新的群成员 (从 GroupMemberStore 拿，它已经通过 ContactStore 重组了头像和昵称)
    final groupId = state.conversationId.replaceFirst('group_', '');
    final members = memberStore.getMembersByGroupId(groupId);

    // 重新计算 isAdmin (对标 PC 响应式逻辑)
    final selfInGroup = members.where((m) => m.userId == state.currentUserId).firstOrNull;
    final isActualAdmin = selfInGroup != null && (selfInGroup.role == 1 || selfInGroup.role == 2);

    return GroupSettingPanel(
      title: groupName,
      groupId: groupId,
      memberCount: members.length,
      avatar: groupAvatar,
      isTop: state.conversation?.isTop ?? false,
      members: members,
      isAdmin: isActualAdmin,
      contactStore: contactStore,
      onToggleTop: () =>
          context.read<GroupSettingBloc>().add(const TogglePinGroupChatEvent()),

      onDeleteConversation: () => context.read<GroupSettingBloc>().add(
        const ShowDeleteGroupDialogEvent(true),
      ),
      onAddMember: () async {
        final List<ContactModel>? result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactSelectorPage(
              title: '添加群成员',
              disabledUserIds: members.map((m) => m.userId).toList(),
            ),
          ),
        );

        if (result != null && result.isNotEmpty) {
          final userIds = result.map((c) => c.userId).toList();
          context.read<GroupSettingBloc>().add(AddGroupMembersEvent(userIds));
        }
      },
      onRemoveMember: (userId) {
        context.read<GroupSettingBloc>().add(RemoveGroupMemberEvent(userId));
      },
    );
  }
}
