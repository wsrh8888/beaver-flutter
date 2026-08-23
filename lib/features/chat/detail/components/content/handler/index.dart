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

import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/features/chat/detail/components/content/handler/text.dart';
import 'package:beaver/features/chat/detail/components/content/handler/audio.dart';
import 'package:beaver/features/chat/detail/components/content/handler/image.dart';
import 'package:beaver/features/chat/detail/components/content/handler/video.dart';
import 'package:beaver/features/chat/detail/components/content/handler/file.dart';
import 'package:beaver/features/chat/detail/components/content/handler/emoji.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/types/business/message.dart';

import 'package:flutter/widgets.dart';

class MessageHandlerFactory {
  static BaseMessageHandler getHandler(MessageType type) {
    switch (type) {
      case MessageType.text:
        return TextHandler();
      case MessageType.audio:
      case MessageType.voice:
        return AudioHandler();
      case MessageType.image:
        return ImageHandler();
      case MessageType.video:
        return VideoHandler();
      case MessageType.file:
        return FileHandler();
      case MessageType.emoji:
        return EmojiHandler();
      case MessageType.mergedForward:
        return ForwardHandler();
      default:
        return TextHandler();
    }
  }

  static Future<void> handleCommand(BuildContext context, String commandId, MessageModel message) async {
    final handler = getHandler(message.type);
    await handler.handleCommand(context, commandId, message);
  }
}
