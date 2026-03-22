import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/widgets/chat_editor.dart';
import 'package:beaver/features/chat/detail/widgets/chat_toolbar.dart';
import 'package:beaver/features/chat/detail/widgets/panel_switcher.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatComposer extends StatefulWidget {
  final String draft;
  final ComposerPanelType activePanel;
  final bool isSending;
  final ValueChanged<String> onDraftChanged;
  final ValueChanged<String> onSendText;
  final ValueChanged<ComposerPanelType> onTogglePanel;
  final ValueChanged<ChatToolbarAction> onToolbarAction;

  const ChatComposer({
    super.key,
    required this.draft,
    required this.activePanel,
    required this.isSending,
    required this.onDraftChanged,
    required this.onSendText,
    required this.onTogglePanel,
    required this.onToolbarAction,
  });

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.draft != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.draft,
        selection: TextSelection.collapsed(offset: widget.draft.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatToolbar(
            activePanel: widget.activePanel,
            onAction: (action) {
              if (action == ChatToolbarAction.emoji) {
                widget.onTogglePanel(ComposerPanelType.emoji);
              } else if (action == ChatToolbarAction.package) {
                widget.onTogglePanel(ComposerPanelType.package);
              } else {
                widget.onToolbarAction(action);
                BeaverToast.show(context, 'This action will be connected later');
              }
            },
          ),
          SizedBox(height: 8.w),
          ChatEditor(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onDraftChanged,
            onSubmitted: _handleSend,
          ),
          SizedBox(height: 8.w),
          _buildSendRow(),
          PanelSwitcher(
            activePanel: widget.activePanel,
            onInsertText: _appendEmojiText,
          ),
        ],
      ),
    );
  }

  Widget _buildSendRow() {
    final canSend = _controller.text.trim().isNotEmpty && !widget.isSending;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 32.w,
          child: ElevatedButton(
            onPressed: canSend ? _handleSend : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFF7D45),
              disabledBackgroundColor: const Color(0xFFCBD2DA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
            ),
            child: Text(
              widget.isSending ? 'Sending...' : 'Send',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _appendEmojiText(String emoji) {
    final text = _controller.text + emoji;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    widget.onDraftChanged(text);
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) {
      return;
    }

    widget.onSendText(text);
    _controller.clear();
    widget.onDraftChanged('');
  }
}
