/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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
