import 'package:beaver/features/chat/private_setting/bloc/bloc.dart';
import 'package:beaver/features/chat/private_setting/bloc/event.dart';
import 'package:beaver/features/chat/private_setting/bloc/state.dart';
import 'package:beaver/features/chat/private_setting/components/private_setting_panel.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PrivateSettingPage extends StatelessWidget {
  final String? conversationId;

  const PrivateSettingPage({super.key, this.conversationId});

  @override
  Widget build(BuildContext context) {
    if (conversationId == null || conversationId!.isEmpty) {
      return const BeaverLayout(
        title: '私聊设置',
        showBack: true,
        child: Center(child: Text('会话不存在')),
      );
    }

    return BlocProvider(
      create: (context) => PrivateSettingBloc()..add(InitPrivateSettingEvent(conversationId!)),
      child: const _PrivateSettingView(),
    );
  }
}

class _PrivateSettingView extends StatelessWidget {
  const _PrivateSettingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateSettingBloc, PrivateSettingState>(
      listener: (context, state) {
        if (state.status == PrivateSettingStatus.deleted) {
          BeaverToast.show(context, '已删除会话');
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
          title: '私聊设置',
          showBack: true,
          isScrollable: true,
          child: Stack(
            children: [
              if (state.status == PrivateSettingStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (state.status == PrivateSettingStatus.error)
                Center(child: Text(state.errorMessage ?? '加载失败'))
              else if (state.conversation != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
                  child: _buildPanel(context, state),
                ),
              if (state.showDeleteDialog)
                BeaverDialog(
                  title: '删除会话',
                  contentText: '确定删除该会话吗？',
                  confirmText: '删除',
                  cancelText: '取消',
                  onCancel: () => context.read<PrivateSettingBloc>().add(const ShowDeletePrivateChatDialogEvent(false)),
                  onConfirm: () => context.read<PrivateSettingBloc>().add(const DeletePrivateChatEvent()),
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

  Widget _buildPanel(BuildContext context, PrivateSettingState state) {
    final conversation = state.conversation!;
    return PrivateSettingPanel(
      nickname: conversation.nickname,
      userId: state.conversationId, 
      avatar: conversation.avatar ?? '',
      isTop: conversation.isTop,
      onToggleTop: () => context.read<PrivateSettingBloc>().add(const TogglePinPrivateChatEvent()),
      onDeleteConversation: () => context.read<PrivateSettingBloc>().add(const ShowDeletePrivateChatDialogEvent(true)),
    );
  }
}
