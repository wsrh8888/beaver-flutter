import 'package:beaver/di/injection.dart';
import 'package:beaver/store/voice/voice.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMessage extends StatelessWidget {
  final VoiceMsg msg;
  final bool isSelf;

  const VoiceMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = msg.fileUrl;
    final duration = msg.duration ?? 1;
    final width = (72 + duration * 6).clamp(96, 200).toDouble().w;

    return BlocBuilder<VoicePlayerStore, VoicePlayerState>(
      bloc: getIt<VoicePlayerStore>(),
      builder: (context, playerState) {
        final color = isSelf
            ? AppColors.chatBubbleSelfText
            : AppColors.chatBubbleOtherText;
        final isPlaying = playerState.isPlaying(fileUrl);
        final hasPlayed = isSelf || playerState.hasPlayed(fileUrl);

        return GestureDetector(
          onTap: fileUrl.isEmpty
              ? null
              : () => getIt<VoicePlayerStore>().toggle(fileUrl),
          child: SizedBox(
            width: width,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isSelf) ...[
                      _VoiceWaveIcon(color: color, isPlaying: isPlaying),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      '${duration}s',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSelf) ...[
                      SizedBox(width: 8.w),
                      _VoiceWaveIcon(color: color, isPlaying: isPlaying, reverse: true),
                    ],
                  ],
                ),
                if (!isSelf && !hasPlayed)
                  Positioned(
                    right: -10.w,
                    top: 6.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D4F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VoiceWaveIcon extends StatelessWidget {
  final Color color;
  final bool isPlaying;
  final bool reverse;

  const _VoiceWaveIcon({
    required this.color,
    required this.isPlaying,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      reverse ? Icons.volume_up_rounded : Icons.volume_up_rounded,
      size: 18.w,
      color: isPlaying ? color.withValues(alpha: 0.85) : color,
    );
  }
}
