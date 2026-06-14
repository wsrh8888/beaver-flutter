import 'package:beaver/di/injection.dart';
import 'package:beaver/store/voice/voice.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioMessage extends StatelessWidget {
  final AudioFileMsg msg;
  final bool isSelf;

  const AudioMessage({super.key, required this.msg, this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    final fileUrl = msg.fileUrl;

    return BlocBuilder<VoicePlayerStore, VoicePlayerState>(
      bloc: getIt<VoicePlayerStore>(),
      builder: (context, playerState) {
        final color = isSelf
            ? AppColors.chatBubbleSelfText
            : AppColors.chatBubbleOtherText;
        final isPlaying = playerState.isPlaying(
          fileUrl.isEmpty ? '' : 'voice-url:$fileUrl',
        );

        return GestureDetector(
          onTap: fileUrl.isEmpty
              ? null
              : () => getIt<VoicePlayerStore>().toggle(fileUrl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying ? Icons.pause_circle_outline : Icons.volume_up,
                size: 18.w,
                color: color,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  msg.fileName ?? '音频文件',
                  style: TextStyle(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
