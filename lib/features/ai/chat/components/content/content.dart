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

import 'package:beaver/features/ai/chat/components/content/message/files.dart';
import 'package:beaver/features/ai/chat/components/content/message/markdown.dart';
import 'package:beaver/features/ai/chat/components/content/message/text.dart';
import 'package:beaver/features/ai/chat/components/content/message/tool.dart';
import 'package:beaver/features/ai/types/chat.dart';
import 'package:beaver/store/ai/ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatContent extends StatefulWidget {
  final List<AiMessage> messages;
  final List<AiArtifact> artifacts;
  final void Function(AiArtifact artifact)? onOpenArtifact;

  const AiChatContent({
    super.key,
    required this.messages,
    this.artifacts = const [],
    this.onOpenArtifact,
  });

  @override
  State<AiChatContent> createState() => _AiChatContentState();
}

class _AiChatContentState extends State<AiChatContent> {
  final _scroll = ScrollController();
  var _stick = true;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollBottom() {
    if (!_stick || !_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  AiArtifact? _artifactForPath(String path) {
    for (final item in widget.artifacts) {
      if (item.path == path) return item;
    }
    return null;
  }

  @override
  void didUpdateWidget(covariant AiChatContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollBottom();
  }

  @override
  Widget build(BuildContext context) {
    _scrollBottom();
    return Container(
      color: const Color(0xFFF9FAFB),
      child: ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        itemCount: widget.messages.length,
        itemBuilder: (_, index) {
          final message = widget.messages[index];
          final mine = message.role == 'user';
          return _MessageRow(
            message: message,
            mine: mine,
            onOpenFile: (path) {
              final art = _artifactForPath(path);
              if (art != null && widget.onOpenArtifact != null) {
                widget.onOpenArtifact!(art);
              }
            },
          );
        },
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  final AiMessage message;
  final bool mine;
  final ValueChanged<String> onOpenFile;

  const _MessageRow({
    required this.message,
    required this.mine,
    required this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!mine) _Avatar(mine: false),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.all(12.w),
              constraints: BoxConstraints(maxWidth: 280.w),
              decoration: BoxDecoration(
                color: mine ? const Color(0xFFFFE6D9) : Colors.white,
                borderRadius: BorderRadius.circular(mine ? 12.r : 4.r),
                border: mine ? null : Border.all(color: const Color(0xFFEBEEF5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!mine && message.tools.isNotEmpty) AiToolMessage(tools: message.tools),
                  if (mine)
                    AiTextMessage(message: message)
                  else if (message.content.isNotEmpty || message.streaming)
                    AiMarkdownMessage(message: message),
                  if (!mine && message.tools.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: AiFileCards(
                        tools: message.tools,
                        onOpenArtifact: (hint) {
                          if (hint.path.isNotEmpty) onOpenFile(hint.path);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (mine) _Avatar(mine: true),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool mine;

  const _Avatar({required this.mine});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEBEEF5)),
      ),
      alignment: Alignment.center,
      child: Icon(
        mine ? Icons.person_outline : Icons.smart_toy_outlined,
        size: 20.sp,
        color: const Color(0xFF636E72),
      ),
    );
  }
}
