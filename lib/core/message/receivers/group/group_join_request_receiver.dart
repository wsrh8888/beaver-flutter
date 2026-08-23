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

import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/di/injection.dart';

/// 群加入请求接收器 - 处理 group_join_requests 表的操作 (对标 PC receivers/group/group-join-request-receiver.ts)
class GroupJoinRequestReceiver {
  GroupJoinRequestBusiness get _groupJoinRequestBusiness => getIt<GroupJoinRequestBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) return;

    for (final update in updates) {
      final table = update['table'] as String?;
      final userId = update['userId']?.toString();
      final groupId = update['groupId']?.toString() ?? update['conversationId']?.toString().replaceFirst('group_', '');
      final data = update['data'] as List?;

      if (table == 'group_join_requests' && userId != null && groupId != null && data != null) {
        for (final item in data) {
          final version = item['version'] as int?;
          if (version != null) {
            await _groupJoinRequestBusiness.handleTableUpdates(userId, groupId, version);
          }
        }
      }
    }
  }
}

final groupJoinRequestReceiver = GroupJoinRequestReceiver();
