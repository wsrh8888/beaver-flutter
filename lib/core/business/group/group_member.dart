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
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/business/group.dart';

const int _userTypeNormal = 1;

/// 群成员业务逻辑 (对标 PC business/group/group-member.ts)
class GroupMemberBusiness {
  final _groupMemberService = getIt<GroupMemberService>();
  final _userService = getIt<UserService>();

  /**
   * 按版本号同步群成员 (对标 PC processBatchRequests)
   */
  Future<void> syncGroupMembersByVersion(String groupId, int version) async {
    try {
      final response = await groupMemberSyncApi(
        IGroupMemberSyncReq(
          groups: [IGroupVersionSyncItem(groupId: groupId, version: version)],
        ),
      );

      if (response.code == 0 &&
          response.result != null &&
          response.result!.groupMembers.isNotEmpty) {
        final members = response.result!.groupMembers;
        await _groupMemberService.batchCreateFromApi(members);

        final syncStatusService = getIt<GroupSyncStatusService>();
        final maxVersionByGroup = <String, int>{};
        for (final member in members) {
          final current = maxVersionByGroup[member.groupId] ?? 0;
          if (member.version > current) {
            maxVersionByGroup[member.groupId] = member.version;
          }
        }
        for (final entry in maxVersionByGroup.entries) {
          await syncStatusService.upsertSyncStatus(
            module: 'members',
            groupId: entry.key,
            version: entry.value,
          );
        }

        await getIt<GroupMemberStore>().updateMembersByGroupIds(
          maxVersionByGroup.keys.toList(),
        );
        print(
          '[GroupMemberBusiness] 群成员同步成功: count=${members.length}',
        );
        getIt<GroupBusiness>().notifyGroupUpdate([groupId]);
      }
    } catch (e) {
      print('[GroupMemberBusiness] syncGroupMembersByVersion failed: $e');
    }
  }

  Future<void> handleTableUpdates(
    String userId,
    String groupId,
    int version,
  ) async {
    final syncStatusService = getIt<GroupSyncStatusService>();
    final localVersions = await syncStatusService.getModuleVersions(
      'members',
      [groupId],
    );
    final localVersion = localVersions.isNotEmpty
        ? (localVersions.first['version'] as int? ?? 0)
        : 0;
    await syncGroupMembersByVersion(groupId, localVersion);
  }

  /// 获取群成员（仅返回普通用户，不含 bot/robot）
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final dbMembers = await _groupMemberService.getGroupMembers(groupId);
    if (dbMembers.isEmpty) {
      return [];
    }

    final userIds = dbMembers.map((m) => m.userId).toList();
    final userInfos = await _userService.getUsersBasicInfo(userIds);
    final userTypeMap = {
      for (final user in userInfos)
        user['userId'] as String: user['userType'] as int,
    };

    return dbMembers
        .where((member) => userTypeMap[member.userId] == _userTypeNormal)
        .map((dbMember) => GroupMember(
              groupId: dbMember.groupId,
              userId: dbMember.userId,
              nickname: dbMember.nickName,
              avatar: dbMember.avatar,
              role: dbMember.role,
              status: dbMember.status,
              joinTime: dbMember.joinTime ??
                  DateTime.now().millisecondsSinceEpoch ~/ 1000,
              version: dbMember.version,
            ))
        .toList();
  }

  /// 统计群内普通用户数量
  Future<int> countHumanMembers(String groupId) async {
    final members = await getGroupMembers(groupId);
    return members.length;
  }
}
