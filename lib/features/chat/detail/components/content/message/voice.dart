import 'package:beaver/di/injection.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/store/voice/voice.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceMessage extends StatelessWidget {
  final VoiceMsg msg;
  final String messageId;
  final bool isSelf;

  const VoiceMessage({
    super.key,
    required this.msg,
    required this.messageId,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = msg.fileUrl;
    final durationSec = _resolveDuration(msg.duration);
    final bubbleWidth = (80 + durationSec * 6).clamp(80, 200).toDouble().w;
    final playbackId = messageId.isNotEmpty
        ? messageId
        : (fileUrl.isEmpty ? '' : 'voice-url:$fileUrl');

    return BlocBuilder<VoicePlayerStore, VoicePlayerState>(
      bloc: getIt<VoicePlayerStore>(),
      builder: (context, playerState) {
        return BlocBuilder<MessageMediaStore, MessageMediaState>(
          bloc: getIt<MessageMediaStore>(),
          builder: (context, mediaState) {
            final isPlaying = playerState.isPlaying(playbackId);
            final hasPlayed = isSelf || mediaState.isPlayed(playbackId);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: playbackId.isEmpty || fileUrl.isEmpty
                  ? null
                  : () {
                      getIt<VoicePlayerStore>().toggleVoice(playbackId, fileUrl);
                    },
              child: SizedBox(
                width: bubbleWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: isSelf
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isSelf) ...[
                          _VoiceWaveIcon(isSelf: isSelf, isPlaying: isPlaying),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          '$durationSec"',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isSelf
                                ? AppColors.chatBubbleSelfText
                                : AppColors.chatBubbleOtherText,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                        if (isSelf) ...[
                          SizedBox(width: 8.w),
                          _VoiceWaveIcon(isSelf: isSelf, isPlaying: isPlaying),
                        ],
                      ],
                    ),
                    if (!isSelf && !hasPlayed)
                      Positioned(
                        left: bubbleWidth + 10.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE75E58),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _resolveDuration(num? raw) {
    if (raw == null || raw <= 0) {
      return 1;
    }
    return raw.round();
  }
}

class _VoiceWaveIcon extends StatefulWidget {
  final bool isSelf;
  final bool isPlaying;

  const _VoiceWaveIcon({required this.isSelf, required this.isPlaying});

  @override
  State<_VoiceWaveIcon> createState() => _VoiceWaveIconState();
}

class _VoiceWaveIconState extends State<_VoiceWaveIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _VoiceWaveIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.isPlaying) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _asset(String name) => 'assets/images/chat/$name';

  @override
  Widget build(BuildContext context) {
    final theme = widget.isSelf ? 'light' : 'dark';
    final size = 18.w;

    return SizedBox(
      width: size,
      height: size,
      child: Transform.flip(
        flipX: widget.isSelf,
        child: widget.isPlaying
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final value = _controller.value;
                  final arc2Opacity = value >= 0.34 ? 1.0 : 0.0;
                  final arc3Opacity = value >= 0.67 ? 1.0 : 0.0;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          _asset('voice-wedge-$theme.svg'),
                          width: size,
                          height: size,
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: arc2Opacity,
                          child: SvgPicture.asset(
                            _asset('voice-arc2-$theme.svg'),
                            width: size,
                            height: size,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: arc3Opacity,
                          child: SvgPicture.asset(
                            _asset('voice-arc3-$theme.svg'),
                            width: size,
                            height: size,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : SvgPicture.asset(
                _asset('voice-icon-$theme.svg'),
                width: size,
                height: size,
              ),
      ),
    );
  }
}
