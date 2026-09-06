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
import 'package:beaver/theme/colors.dart';
import 'package:beaver/features/chat/detail/components/bottom/bottom.dart';
import 'package:beaver/features/chat/detail/components/content/content.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('chat-detail-page');

class ChatDetailPage extends StatefulWidget {
  final String? conversationId;
  const ChatDetailPage({super.key, this.conversationId});
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late final ChatBloc _chatBloc;
  String? _loadedConversationId;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(conversationId: widget.conversationId);
    _ensureConversationLoaded();
  }

  @override
  void didUpdateWidget(covariant ChatDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      _ensureConversationLoaded(force: true);
    }
  }

  void _ensureConversationLoaded({bool force = false}) {
    final conversationId = widget.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      _logger.error({'text': '会话ID缺失，无法加载会话'});
      return;
    }
    if (!force && _loadedConversationId == conversationId) return;
    _loadedConversationId = conversationId;
    _chatBloc.add(LoadMessagesEvent(conversationId));
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStatus.error && state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final isMultiSelect = state.status == ChatStatus.multiSelect;
          final conversationId =
              widget.conversationId ?? state.conversationId ?? '';
          return BeaverLayout(
            title: _resolveTitle(context, state),
            showBack: true,
            showBackground: false,
            isScrollable: false,
            rightSlot: isMultiSelect
                ? _buildCancelButton()
                : _buildMoreButton(context),
            child: ColoredBox(
              color: AppColors.chatBackground,
              child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _chatBloc.add(const DismissComposerEvent());
                    },
                    child: const ChatContent(),
                  ),
                ),
                ChatBottom(
                  conversationId: conversationId,
                  draft: state.draft,
                  activePanel: state.activePanel,
                  isVoiceMode: state.isVoiceMode,
                  isSending: state.isSending,
                  isMultiSelect: isMultiSelect,
                  editingMessage: state.editingMessage,
                  replyingMessage: state.replyingMessage,
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final conversationId = widget.conversationId ?? '';
        if (conversationId.isEmpty) {
          BeaverToast.show(context, '找不到会话');
          return;
        }
        
        // 根据会话类型跳转不同路由
        final route = conversationId.startsWith('group_') 
            ? AppRoutes.groupChatSetting 
            : AppRoutes.privateChatSetting;
            
        context.push('$route?id=$conversationId');
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

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () =>
          context.read<ChatBloc>().add(const CancelMultiSelectEvent()),
      child: Text(
        '取消',
        style: TextStyle(
          color: const Color(0xFFFF7D45),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _resolveTitle(BuildContext context, ChatState state) {
    final id = widget.conversationId ?? '';
    final chatItem = context.select<ChatStore, dynamic>((store) {
      for (final item in store.state.conversations) {
        if (item.conversationId == id) return item;
      }
      return null;
    });
    final titleFromStore = chatItem?.nickname?.toString() ?? '';
    if (titleFromStore.isNotEmpty) return _truncateTitle(titleFromStore);
    final titleFromConversation = state.conversation?.nickname ?? '';
    if (titleFromConversation.isNotEmpty) {
      return _truncateTitle(titleFromConversation);
    }
    return '聊天';
  }

  String _truncateTitle(String title) =>
      title.length <= 10 ? title : '${title.substring(0, 10)}...';
}
