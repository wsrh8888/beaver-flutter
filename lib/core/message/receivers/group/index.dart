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

import './group.dart';
import './group_join_request_receiver.dart';
import './group_member_receiver.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-message-router');

/// Group message router.
class GroupMessageRouter {
  /**
   * 处理群组消息
   * @param wsMessage WebSocket 消息内容
   */
  Future<void> processGroupMessage(Map<String, dynamic> wsMessage) async {
    final data = wsMessage['data'] as Map<String, dynamic>?;

    if (data == null) {
      _logger.warn({
        'text': '收到群组消息但缺少data字段',
        'data': {'wsMessage': wsMessage},
      });
      return;
    }

    final type = data['type'] as String?;
    final body = data['body'] as Map<String, dynamic>?;

    if (type == null || body == null) return;

    switch (type) {
      case 'group_receive':
        await groupReceiver.handleTableUpdates(body);
        break;
      case 'group_member_receive':
        await groupMemberReceiver.handleTableUpdates(body);
        break;
      case 'group_join_request_receive':
        await groupJoinRequestReceiver.handleTableUpdates(body);
        break;
      default:
        break;
    }
  }
}

final groupMessageRouter = GroupMessageRouter();
