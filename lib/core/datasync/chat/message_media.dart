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
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-chat-message-media');

/// 消息媒体状态同步器（语音已听等）
class MessageMediaSync {
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) {
      _logger.warn({'text': '消息媒体状态同步跳过：未登录（userId 为空）'});
      return;
    }
    _logger.info({'text': '开始同步消息媒体状态'});
    try {
      await getIt<MessageMediaStore>().sync();
      _logger.info({'text': '消息媒体状态同步完成'});
    } catch (e) {
      _logger.warn({'text': '消息媒体状态同步异常', 'data': {'error': e.toString()}});
    }
  }
}

final messageMediaSync = MessageMediaSync();
