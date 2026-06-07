import 'package:beaver/theme/colors.dart';
import 'package:beaver/features/chat/detail/components/bottom/bar.dart';
import 'package:beaver/features/chat/detail/components/bottom/action.dart';
import 'package:beaver/features/chat/detail/components/bottom/panels/emoji/index.dart';
import 'package:beaver/features/chat/detail/components/bottom/panels/tool/menu.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBottom extends StatefulWidget {
  final String conversationId;
  final String draft;
  final ComposerPanelType activePanel;
  final bool isVoiceMode;
  final bool isSending;
  final bool isMultiSelect;
  const ChatBottom({super.key, required this.conversationId, required this.draft, required this.activePanel, required this.isVoiceMode, required this.isSending, required this.isMultiSelect});
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
  Widget build(BuildContext context) {
    if (widget.isMultiSelect) return const MultiSelectAction();
    final currentInsets = MediaQuery.of(context).viewInsets.bottom;
    if (currentInsets > 0) _keyboardHeight = currentInsets;
    return Container(
      color: AppColors.chatInputBackground,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ChatBar(
          conversationId: widget.conversationId,
          activePanel: widget.activePanel, 
          isVoiceMode: widget.isVoiceMode, 
          isSending: widget.isSending, 
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
