import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/components/composer/chat_composer.dart';
import 'package:beaver/features/chat/detail/components/message/message_viewport.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ChatDetailView extends StatelessWidget {
  final String? conversationId;

  const ChatDetailView({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.status == ChatStatus.error && state.errorMessage != null) {
          BeaverToast.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: _resolveTitle(context, state),
          showBack: true,
          showBackground: true,
          backgroundHeight: 160,
          isScrollable: false,
          rightSlot: _buildMoreButton(context),
          child: Column(
            children: [
              Expanded(
                child: MessageViewport(
                  messages: state.messages,
                  isLoading: state.status == ChatStatus.loading,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () {
                    context.read<ChatBloc>().add(const LoadMoreMessagesEvent());
                  },
                ),
              ),
              ChatComposer(
                draft: state.draft,
                activePanel: state.activePanel,
                isSending: state.isSending,
                onDraftChanged: (draft) {
                  context.read<ChatBloc>().add(UpdateDraftEvent(draft));
                },
                onSendText: (text) {
                  context
                      .read<ChatBloc>()
                      .add(SendMessageEvent(text, MessageType.text));
                },
                onTogglePanel: (panel) {
                  context
                      .read<ChatBloc>()
                      .add(ToggleComposerPanelEvent(panel));
                },
                onToolbarAction: (action) {
                  context.read<ChatBloc>().add(ToolbarActionEvent(action));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final id = conversationId ?? '';
        if (id.isEmpty) {
          BeaverToast.show(context, 'Conversation not found');
          return;
        }
        context.push('${AppRoutes.chatSetting}?id=$id');
      },
      child: Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/chat/more.svg',
          width: 22.w,
          height: 22.w,
        ),
      ),
    );
  }

  String _resolveTitle(BuildContext context, ChatState state) {
    final id = conversationId ?? '';
    final chatItem = context.select<ChatStore, dynamic>((store) {
      for (final item in store.state.conversations) {
        if (item.conversationId == id) {
          return item;
        }
      }
      return null;
    });

    final titleFromStore = chatItem?.nickname?.toString() ?? '';
    if (titleFromStore.isNotEmpty) {
      return _truncateTitle(titleFromStore);
    }

    final titleFromConversation =
        (state.conversation is Map<String, dynamic>)
            ? (state.conversation['title']?.toString() ?? '')
            : '';

    if (titleFromConversation.isNotEmpty) {
      return _truncateTitle(titleFromConversation);
    }

    return 'Chat';
  }

  String _truncateTitle(String title) {
    if (title.length <= 10) {
      return title;
    }
    return '${title.substring(0, 10)}...';
  }
}
