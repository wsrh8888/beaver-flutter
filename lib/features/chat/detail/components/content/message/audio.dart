import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioMessage extends StatelessWidget {
  final AudioFileMsg msg;
  final bool isSelf;
  const AudioMessage({super.key, required this.msg, this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    final color = isSelf ? Colors.white : const Color(0xFF636E72);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.volume_up, size: 18.w, color: color),
        SizedBox(width: 8.w),
        Text("${msg.fileName ?? '语音消息'}", style: TextStyle(color: color)),
      ],
    );
  }
}
