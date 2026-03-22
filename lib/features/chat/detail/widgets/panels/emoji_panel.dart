import 'package:beaver/store/emoji/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiPanel extends StatelessWidget {
  final ValueChanged<String> onInsertText;

  const EmojiPanel({
    super.key,
    required this.onInsertText,
  });

  static const List<String> _defaultEmoji = [
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
    '??',
  ];

  @override
  Widget build(BuildContext context) {
    final customEmojis = context.select<EmojiStore, List<dynamic>>(
      (store) => store.state.customEmojis,
    );

    return Column(
      children: [
        _buildHeader(customEmojis.length),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
            child: GridView.builder(
              itemCount: _defaultEmoji.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.w,
              ),
              itemBuilder: (context, index) {
                final emoji = _defaultEmoji[index];
                return _EmojiCell(
                  label: emoji,
                  onTap: () => onInsertText(emoji),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(int customCount) {
    return Container(
      height: 36.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        'Emoji  ¡¤  Custom: $customCount',
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF7E8792),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmojiCell extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _EmojiCell({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFE7ECF1)),
        ),
        child: Text(label, style: TextStyle(fontSize: 20.sp)),
      ),
    );
  }
}
