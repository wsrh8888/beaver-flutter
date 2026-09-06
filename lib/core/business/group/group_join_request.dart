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

import 'dart:async';
import 'package:beaver/core/database/services/group/group_join_request.dart';
import 'package:beaver/core/database/services/group/group.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/business/group.dart';
import 'package:intl/intl.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('group-join-request-business');

/// 群加入请求业务逻辑 (对标 PC business/group/group-join-request.ts)
class GroupJoinRequestBusiness {
  final _joinRequestService = getIt<GroupJoinRequestService>();
  final _groupService = getIt<GroupService>();
  final _userBusiness = getIt<UserBusiness>();

  Future<void> handleTableUpdates(String userId, String groupId, int version) async {
    await syncGroupJoinRequestsByVersion(groupId, version);
  }

  Future<void> syncGroupJoinRequestsByVersion(String groupId, int version) async {
     try {
      final response = await groupJoinRequestSyncApi(
        IGroupJoinRequestSyncReq(
          groups: [IGroupVersionSyncItem(groupId: groupId, version: version)],
        ),
      );

      if (response.code == 0 && response.result != null && response.result!.groupJoinRequests.isNotEmpty) {
        await _joinRequestService.batchCreate(response.result!.groupJoinRequests);
        _logger.info({
          'text': '入群申请同步成功',
          'data': {
            'count': response.result!.groupJoinRequests.length,
          },
        });
      }
    } catch (e) {
      _logger.error({
        'text': '同步入群申请失败',
        'data': {'groupId': groupId, 'error': e.toString()},
      });
    }
  }

  Future<List<GroupNotification>> getGroupNotifications() async {
    final requests = await _joinRequestService.getAllRequests();
    if (requests.isEmpty) return [];

    final groupIds = requests.map((r) => r.groupId).toSet().toList();
    final userIds = requests.map((r) => r.applicantUserId).toSet().toList();

    final groups = await _groupService.getGroupsByIds(groupIds);
    final groupMap = {for (var g in groups) g.groupId: g};

    final userInfos = await _userBusiness.getUsersBasicInfo(userIds);
    final userMap = {for (var u in userInfos) u.userId: u};

    final notifications = requests.map((r) {
      final group = groupMap[r.groupId];
      final user = userMap[r.applicantUserId];

      final createdAt = r.createdAt != null
          ? DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(DateTime.fromMillisecondsSinceEpoch(r.createdAt! * 1000))
          : '';

      return GroupNotification(
        id: r.id,
        groupId: r.groupId,
        groupName: group?.title ?? '未知群聊',
        groupAvatar: group?.avatar ?? '',
        applicantUserId: r.applicantUserId,
        applicantNickname: user?.nickname ?? r.applicantUserId,
        applicantAvatar: user?.avatar ?? '',
        message: r.message,
        status: r.status,
        createdAt: createdAt,
      );
    }).toList();

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  Future<bool> updateGroupRequestStatus(int id, int status) async {
    return true;
  }

  Future<int> getUnreadGroupNotificationCount() async {
    return await _joinRequestService.getUnreadCount();
  }
}
