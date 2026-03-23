import 'package:beaver/features/chat/setting/bloc/bloc.dart';
import 'package:beaver/features/chat/setting/bloc/event.dart';
import 'package:beaver/features/chat/setting/bloc/state.dart';
import 'package:beaver/features/chat/setting/components/group_setting_panel.dart';
import 'package:beaver/features/chat/setting/components/private_setting_panel.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatSettingPage extends StatelessWidget {
  final String? conversationId;

  const ChatSettingPage({super.key, this.conversationId});

  @override
  Widget build(BuildContext context) {
    if (conversationId == null || conversationId!.isEmpty) {
      return const BeaverLayout(
        title: '聊天设置',
        showBack: true,
        child: Center(child: Text('会话不存在')),
      );
    }

    return BlocProvider(
      create: (context) => ChatSettingBloc()..add(InitChatSettingEvent(conversationId!)),
      child: const _ChatSettingView(),
    );
  }
}

class _ChatSettingView extends StatelessWidget {
  const _ChatSettingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatSettingBloc, ChatSettingState>(
      listener: (context, state) {
        if (state.status == ChatSettingStatus.deleted) {
          BeaverToast.show(context, '已删除会话');
          // Pop both setting and chat detail
          if (Navigator.of(context).canPop()) {
            context.pop();
          }
          if (Navigator.of(context).canPop()) {
            context.pop();
          }
        }
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          BeaverToast.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: '聊天设置',
          showBack: true,
          isScrollable: true,
          child: Stack(
            children: [
              if (state.status == ChatSettingStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (state.status == ChatSettingStatus.error)
                Center(child: Text(state.errorMessage ?? '加载失败'))
              else if (state.conversation != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
                  child: state.conversationId.startsWith('group_')
                      ? _buildGroupPanel(context, state)
                      : _buildPrivatePanel(context, state),
                ),
              if (state.showDeleteDialog)
                BeaverDialog(
                  title: '删除会话',
                  contentText: '确定删除该会话吗？',
                  confirmText: '删除',
                  cancelText: '取消',
                  onCancel: () => context.read<ChatSettingBloc>().add(const ShowDeleteDialogEvent(false)),
                  onConfirm: () => context.read<ChatSettingBloc>().add(const DeleteConversationEvent()),
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

  Widget _buildPrivatePanel(BuildContext context, ChatSettingState state) {
    final conversation = state.conversation!;
    // Note: Peer ID parsing is now handled by the Business layer or BLoC if needed, 
    // but here we just need the display data from ChatModel.
    // ChatModel already has the resolved nickname and avatar.
    
    return PrivateSettingPanel(
      nickname: conversation.nickname,
      userId: state.conversationId, // Using conversationId as fallback for userId display
      avatar: conversation.avatar ?? '',
      isTop: conversation.isTop,
      onToggleTop: () => context.read<ChatSettingBloc>().add(const TogglePinChatEvent()),
      onDeleteConversation: () => context.read<ChatSettingBloc>().add(const ShowDeleteDialogEvent(true)),
    );
  }

  Widget _buildGroupPanel(BuildContext context, ChatSettingState state) {
    final conversation = state.conversation!;
    
    return GroupSettingPanel(
      title: conversation.nickname,
      groupId: state.conversationId.replaceFirst('group_', ''),
      memberCount: 0, // Business layer needs to provide this, currently not in ChatModel
      avatar: conversation.avatar ?? '',
      isTop: conversation.isTop,
      onToggleTop: () => context.read<ChatSettingBloc>().add(const TogglePinChatEvent()),
      onDeleteConversation: () => context.read<ChatSettingBloc>().add(const ShowDeleteDialogEvent(true)),
    );
  }
}

