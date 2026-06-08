import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MomentBottomInput extends StatefulWidget {
  final bool isLiked;
  final String replyPlaceholder;
  final VoidCallback onQuickLike;
  final ValueChanged<String> onSendComment;
  final VoidCallback onCloseReply;
  final int openInputKey;

  const MomentBottomInput({
    super.key,
    required this.isLiked,
    required this.replyPlaceholder,
    required this.onQuickLike,
    required this.onSendComment,
    required this.onCloseReply,
    this.openInputKey = 0,
  });

  @override
  State<MomentBottomInput> createState() => _MomentBottomInputState();
}

class _MomentBottomInputState extends State<MomentBottomInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showFullInput = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant MomentBottomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openInputKey != oldWidget.openInputKey && widget.openInputKey > 0) {
      _openInput();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _showFullInput) {
      _closeInput();
    }
  }

  void _openInput() {
    setState(() => _showFullInput = true);
    Future.microtask(() => _focusNode.requestFocus());
  }

  void _closeInput() {
    setState(() {
      _showFullInput = false;
      _controller.clear();
    });
    widget.onCloseReply();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSendComment(text);
    _closeInput();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E5E5), width: 0.5.w),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _showFullInput ? _buildExpandedInput() : _buildQuickActions(),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _openInput,
              child: Container(
                height: 44.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(color: const Color(0xFFEBEEF5)),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.replyPlaceholder,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: widget.onQuickLike,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.isLiked
                    ? const Color(0xFFFFE6D9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.w),
              ),
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.w,
                color: widget.isLiked
                    ? const Color(0xFFFF4757)
                    : const Color(0xFF636E72),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedInput() {
    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE86835)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: widget.replyPlaceholder,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFB2BEC3),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12.w),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _send(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _controller.text.trim().isEmpty ? null : _send,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.w,
                    ),
                    decoration: BoxDecoration(
                      gradient: _controller.text.trim().isEmpty
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                            ),
                      color: _controller.text.trim().isEmpty
                          ? const Color(0xFFCCCCCC)
                          : null,
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: Text(
                      '发送',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
