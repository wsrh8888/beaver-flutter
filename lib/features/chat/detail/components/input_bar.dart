import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/core/database/database.dart';

class InputBar extends StatefulWidget {
  final Function(String, MessageType) onSendMessage;

  const InputBar({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceMode = false;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text, MessageType.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 16.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFEBEEF5),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isVoiceMode = !_isVoiceMode;
              });
            },
            child: Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              child: Icon(
                _isVoiceMode ? Icons.keyboard : Icons.mic,
                size: 32.w,
                color: const Color(0xFF636E72),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(32.w),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onSubmitted: (value) => _sendMessage(),
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  hintStyle: TextStyle(
                    color: const Color(0xFFB2BEC3),
                    fontSize: 30.w,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.w,
                  ),
                ),
                style: TextStyle(
                  fontSize: 30.w,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              child: Icon(
                Icons.send,
                size: 32.w,
                color: const Color(0xFFFF7D45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
