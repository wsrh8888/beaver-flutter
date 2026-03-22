import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiMessage extends StatelessWidget {
  final EmojiMsg msg;
  const EmojiMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/emoji/default/${msg.emojiId}.gif',
      width: 80.w,
      height: 80.w,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.sentiment_satisfied, size: 60.w, color: Colors.orangeAccent),
    );
  }
}
