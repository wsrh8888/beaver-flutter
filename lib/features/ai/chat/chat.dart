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

import 'package:beaver/features/ai/chat/components/artifact/sheet.dart';
import 'package:beaver/features/ai/chat/components/bottom/composer.dart';
import 'package:beaver/features/ai/chat/components/content/content.dart';
import 'package:beaver/features/ai/chat/components/header/header.dart';
import 'package:beaver/features/ai/types/chat.dart';
import 'package:beaver/store/ai/ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiChatPage extends StatefulWidget {
  final String threadId;

  const AiChatPage({super.key, required this.threadId});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _openArtifacts(BuildContext context, AiThread thread, AiStore store) {
    if (thread.artifacts.isEmpty) return;
    final active = store.state.activeArtifactId;
    AiArtifact? pick;
    for (final item in thread.artifacts) {
      if (item.id == active) pick = item;
    }
    pick ??= thread.artifacts.first;
    store.setActiveArtifact(pick.id);
    showAiArtifactSheet(context, pick);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiStore, AiStoreState>(
      builder: (context, state) {
        final thread = state.threadOf(widget.threadId);
        final messages = thread?.messages ?? const <AiMessage>[];
        final store = context.read<AiStore>();
        final computer = state.computer;
        final remoteHint = thread?.remote == true && computer != null
            ? ' · ${computer.deviceName.isNotEmpty ? computer.deviceName : '电脑'}执行'
            : (thread?.remote == true ? ' · 电脑空间' : '');
        return Column(
          children: [
            AiChatHeader(
              title: '${thread?.title ?? '会话'}$remoteHint',
              onMenu: () => Scaffold.of(context).openDrawer(),
              showArtifact: (thread?.artifacts.isNotEmpty ?? false),
              onArtifact: thread == null ? null : () => _openArtifacts(context, thread, store),
            ),
            Expanded(
              child: AiChatContent(
                messages: messages,
                artifacts: thread?.artifacts ?? const [],
                onOpenArtifact: (artifact) {
                  store.setActiveArtifact(artifact.id);
                  showAiArtifactSheet(context, artifact);
                },
              ),
            ),
            AiComposer(
              controller: _input,
              sending: state.streamingThreadId.isNotEmpty,
              hint: state.cloudMode ? '继续追问' : '给这台电脑下指令',
              onSend: () {
                final text = _input.text;
                _input.clear();
                store.reply(widget.threadId, text);
              },
            ),
          ],
        );
      },
    );
  }
}
