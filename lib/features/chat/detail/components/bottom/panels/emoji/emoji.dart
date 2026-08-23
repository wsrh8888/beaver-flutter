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

import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/utils/emoji.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmojiGrid extends StatelessWidget {
  final String? packageId;
  final TextEditingController? controller;
  final String conversationId;

  const EmojiGrid({
    super.key,
    this.packageId,
    this.controller,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    if (packageId == null || packageId == 'default') {
      return _buildDefaultGrid();
    }

    return BlocBuilder<EmojiStore, EmojiStoreState>(
      builder: (context, state) {
        final emojis = state.packageEmojisMap[packageId!] ?? [];
        if (emojis.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: EdgeInsets.all(12.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16.w,
            crossAxisSpacing: 16.w,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            final emoji = emojis[index];
            return GestureDetector(
              onTap: () {
                final bloc = context.read<ChatBloc>();
                bloc.add(
                  SendMessageEvent(
                    MessageContentModel(
                      type: MessageType.emoji,
                      emojiMsg: EmojiMsg(
                        fileUrl: emoji.fileKey,
                        emojiId: emoji.emojiId.toString(),
                        packageId: packageId ?? '',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    conversationId: conversationId,
                  ),
                );
                bloc.add(const DismissComposerEvent());
              },
              onLongPress: () {
                context.push(
                  '${AppRoutes.emojiDetail}?emojiId=${emoji.emojiId}',
                );
              },
              child: Hero(
                tag: 'emoji_${emoji.emojiId}',
                child: BeaverCachedImage(
                  fileUrl: emoji.fileKey,
                  fit: BoxFit.contain,
                  enableFullscreen: false,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDefaultGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
      ),
      itemCount: defaultEmojiList.length,
      itemBuilder: (context, index) {
        final emoji = defaultEmojiList[index];
        return GestureDetector(
          onTap: () {
            if (controller != null) {
              final text = controller!.text;
              final selection = controller!.selection;
              final newText = text.replaceRange(
                selection.start == -1 ? text.length : selection.start,
                selection.end == -1 ? text.length : selection.end,
                emoji.name,
              );
              controller!.text = newText;
              controller!.selection = TextSelection.collapsed(
                offset:
                    (selection.start == -1 ? text.length : selection.start) +
                    emoji.name.length,
              );
            }
          },
          child: Center(
            child: Image.asset(emoji.path, width: 32.w, height: 32.w),
          ),
        );
      },
    );
  }
}
