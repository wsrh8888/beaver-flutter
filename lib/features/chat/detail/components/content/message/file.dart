import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileMessage extends StatelessWidget {
  final FileMsg msg;
  final bool isSelf;
  const FileMessage({super.key, required this.msg, this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    final textColor = isSelf ? Colors.white : const Color(0xFF2D3436);
    final subColor = isSelf ? Colors.white70 : const Color(0xFF636E72);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                msg.fileName ?? "未命名文件",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor),
              ),
              SizedBox(height: 4.w),
              Text("${msg.size ?? 0} B", style: TextStyle(fontSize: 12.sp, color: subColor)),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Icon(Icons.description, size: 32.w, color: const Color(0xFF2196F3)),
      ],
    );
  }
}
