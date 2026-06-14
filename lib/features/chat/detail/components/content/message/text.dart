import 'package:beaver/shared/utils/emoji.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextMessage extends StatelessWidget {
  final TextMsg msg;
  final bool isSelf;
  final double? emojiSize;
  final double? fontSize;

  const TextMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
    this.emojiSize,
    this.fontSize,
  });

  static final _emojiTokenPattern = RegExp(r'\[[^\]]+\]');

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize ?? 15.sp,
      height: 1.4,
    );
    final size = emojiSize ?? 35.w;

    return Text.rich(
      TextSpan(style: style, children: _parseContent(msg.content, size)),
    );
  }

  List<InlineSpan> _parseContent(String text, double size) {
    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final match in _emojiTokenPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }

      final token = match.group(0)!;
      final assetPath = getEmojiPath(token);
      if (assetPath != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Image.asset(
                assetPath,
                width: size,
                height: size,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: token));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return spans;
  }
}
