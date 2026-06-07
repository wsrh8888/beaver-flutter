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
      create: (context) => PrivateSettingBloc()
        ..add(InitPrivateSettingEvent(conversationId!)),
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
        if (state.status == PrivateSettingStatus.historyCleared) {
          BeaverToast.show(context, '已清空聊天记录');
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
          overlay: _buildOverlay(context, state),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget? _buildOverlay(BuildContext context, PrivateSettingState state) {
    if (!state.showDeleteDialog &&
        !state.showClearDialog &&
        !state.isSaving) {
      return null;
    }

    return Stack(
      children: [
        if (state.showDeleteDialog)
          BeaverDialog(
            title: '删除会话',
            contentText: '确定删除该会话吗？',
            confirmText: '删除',
            confirmColor: const Color(0xFFF44336),
            cancelText: '取消',
            maskClosable: false,
            onCancel: () => context.read<PrivateSettingBloc>().add(
                  const ShowDeletePrivateChatDialogEvent(false),
                ),
            onConfirm: () => context.read<PrivateSettingBloc>().add(
                  const DeletePrivateChatEvent(),
                ),
          ),
        if (state.showClearDialog)
          BeaverDialog(
            title: '清空聊天记录',
            contentText: '确定清空该会话的聊天记录吗？',
            confirmText: '清空',
            confirmColor: const Color(0xFFF44336),
            cancelText: '取消',
            maskClosable: false,
            onCancel: () => context.read<PrivateSettingBloc>().add(
                  const ShowClearHistoryDialogEvent(false),
                ),
            onConfirm: () => context.read<PrivateSettingBloc>().add(
                  const ClearChatHistoryEvent(),
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

  Widget _buildBody(BuildContext context, PrivateSettingState state) {
    if (state.status == PrivateSettingStatus.loading) {
      return SizedBox(
        height: 400.w,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == PrivateSettingStatus.error) {
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

  Widget _buildPanel(BuildContext context, PrivateSettingState state) {
    final conversation = state.conversation!;
    return PrivateSettingPanel(
      nickname: conversation.nickname,
      userId: state.conversationId,
      avatar: conversation.avatar ?? '',
      isTop: conversation.isTop,
      onToggleTop: () => context.read<PrivateSettingBloc>().add(
            const TogglePinPrivateChatEvent(),
          ),
      onClearHistory: () => context.read<PrivateSettingBloc>().add(
            const ShowClearHistoryDialogEvent(true),
          ),
      onDeleteConversation: () => context.read<PrivateSettingBloc>().add(
            const ShowDeletePrivateChatDialogEvent(true),
          ),
    );
  }
}
