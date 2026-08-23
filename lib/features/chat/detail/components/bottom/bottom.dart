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

import 'package:beaver/theme/colors.dart';
import 'package:beaver/features/chat/detail/components/bottom/bar.dart';
import 'package:beaver/features/chat/detail/components/bottom/edit_bar.dart';
import 'package:beaver/features/chat/detail/components/bottom/reply_bar.dart';
import 'package:beaver/features/chat/detail/components/bottom/action.dart';
import 'package:beaver/features/chat/detail/components/bottom/panels/emoji/index.dart';
import 'package:beaver/features/chat/detail/components/bottom/panels/tool/menu.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBottom extends StatefulWidget {
  final String conversationId;
  final String draft;
  final ComposerPanelType activePanel;
  final bool isVoiceMode;
  final bool isSending;
  final bool isMultiSelect;
  final MessageModel? editingMessage;
  final MessageModel? replyingMessage;
  const ChatBottom({super.key, required this.conversationId, required this.draft, required this.activePanel, required this.isVoiceMode, required this.isSending, required this.isMultiSelect, this.editingMessage, this.replyingMessage});
  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> {
  double _keyboardHeight = 280.w;
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Only update bloc if draft has changed to avoid loops
    // But since draft is in Bloc, we should ideally use the controller as truth
    // and sync only when necessary.
  }

  @override
  void didUpdateWidget(ChatBottom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.draft != _controller.text) {
      _controller.text = widget.draft;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
    if (widget.editingMessage != null &&
        widget.editingMessage != oldWidget.editingMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
    if (widget.replyingMessage != null &&
        widget.replyingMessage != oldWidget.replyingMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMultiSelect) return const MultiSelectAction();
    final currentInsets = MediaQuery.of(context).viewInsets.bottom;
    if (currentInsets > 0) _keyboardHeight = currentInsets;
    return Container(
      color: AppColors.chatInputBackground,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (widget.editingMessage != null)
          EditMessageBar(message: widget.editingMessage!),
        if (widget.editingMessage == null && widget.replyingMessage != null)
          ReplyMessageBar(message: widget.replyingMessage!),
        ChatBar(
          conversationId: widget.conversationId,
          activePanel: widget.activePanel, 
          isVoiceMode: widget.isVoiceMode, 
          isSending: widget.isSending,
          isEditing: widget.editingMessage != null,
          isReplying: widget.replyingMessage != null,
          focusNode: _focusNode,
          controller: _controller,
        ), 
        _buildPanelArea()
      ]),
    );
  }
  Widget _buildPanelArea() {
    if (widget.activePanel == ComposerPanelType.none) return SizedBox(height: 4.w);
    return Container(height: _keyboardHeight, decoration: BoxDecoration(color: const Color(0xFFF8FAFC), border: Border(top: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w))), child: _resolvePanel());
  }
  Widget _resolvePanel() {
    switch (widget.activePanel) {
      case ComposerPanelType.emoji: return EmojiPanel(controller: _controller, conversationId: widget.conversationId);
      case ComposerPanelType.package: return ToolMenu(conversationId: widget.conversationId);
      default: return const SizedBox.shrink();
    }
  }
}
