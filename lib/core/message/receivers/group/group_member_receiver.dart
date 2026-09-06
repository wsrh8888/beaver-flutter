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

import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('receiver-group-member');

/// 群成员接收器 - 处理 groups / group_members 表的操作 (对标 PC group-member-receiver.ts)
class GroupMemberReceiver {
  GroupBusiness get _groupBusiness => getIt<GroupBusiness>();
  GroupMemberBusiness get _groupMemberBusiness => getIt<GroupMemberBusiness>();

  Future<void> handleTableUpdates(Map<String, dynamic> body) async {
    final updates = (body['tables'] ?? body['tableUpdates']) as List?;
    if (updates == null) {
      _logger.warn({'text': '收到群成员表更新但 updates 为空'});
      return;
    }
    _logger.info({'text': '开始处理群成员表更新', 'data': {'count': updates.length}});

    for (final update in updates) {
      final table = update['table'] as String?;
      final userId = update['userId']?.toString();
      final groupId = update['groupId']?.toString() ??
          update['conversationId']?.toString().replaceFirst('group_', '');
      final data = update['data'] as List?;
      if (data == null) continue;

      if (table == 'groups') {
        for (final item in data) {
          final itemGroupId = item['groupId']?.toString() ??
              groupId ??
              item['conversationId']?.toString().replaceFirst('group_', '');
          final version = item['version'] as int?;
          if (itemGroupId != null && version != null) {
            try {
              await _groupBusiness.syncGroupByVersion(itemGroupId, version);
            } catch (e) {
              _logger.warn({'text': '按版本同步群组失败', 'data': {'groupId': itemGroupId, 'version': version, 'error': e.toString()}});
            }
          }
        }
      } else if (table == 'group_members') {
        for (final item in data) {
          final itemGroupId = item['groupId']?.toString() ??
              groupId ??
              item['conversationId']?.toString().replaceFirst('group_', '');
          final itemUserId = item['userId']?.toString() ?? userId;
          final version = item['version'] as int?;
          if (itemGroupId != null && version != null) {
            try {
              await _groupMemberBusiness.handleTableUpdates(
                itemUserId ?? '',
                itemGroupId,
                version,
              );
            } catch (e) {
              _logger.warn({'text': '按版本同步群成员失败', 'data': {'groupId': itemGroupId, 'userId': itemUserId, 'version': version, 'error': e.toString()}});
            }
          }
        }
      }
    }
  }
}

final groupMemberReceiver = GroupMemberReceiver();
