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

import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart';
import 'package:drift/drift.dart';

/// 群资料同步器（对应服务器 group 表）
class GroupSync {
  /// 检查并同步群资料
  Future<void> checkAndSync() async {
    try {
      final datasyncService = getIt<DatasyncService>();
      final groupService = getIt<GroupService>();
      final syncStatusService = getIt<GroupSyncStatusService>();

      // 获取本地同步游标（version=-1 表示按版本发现变更，对齐 PC）
      final cursor = await datasyncService.get('groups');
      final lastSyncVersion = cursor?.version ?? 0;

      // 获取服务器上变更的群组版本信息
      final response = await datasyncGetSyncGroupInfoApi(
        IGetSyncGroupInfoReq(since: lastSyncVersion),
      );
      if (response.code != 0 || response.result == null) {
        // print('[GroupSync] 获取群组版本失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要更新的群组
      final needUpdateGroups = await _compareAndFilterGroupVersions(
        syncStatusService,
        response.result!.groupVersions,
      );

      if (needUpdateGroups.isNotEmpty) {
        // 有需要更新的群资料
        await _syncGroupData(groupService, syncStatusService, needUpdateGroups);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'groups',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      // print('[GroupSync] 群资料同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要更新的群组信息
  Future<List<IGroupVersionSyncItem>> _compareAndFilterGroupVersions(
    GroupSyncStatusService syncStatusService,
    List<IGroupInfoVersionItem> groupVersions,
  ) async {
    if (groupVersions.isEmpty) return [];

    // 提取所有变更的群组ID
    final groupIds = groupVersions.map((item) => item.groupId).toList();

    // 查询本地已存在的群组资料版本状态
    final localVersions = await syncStatusService.getModuleVersions(
      'info',
      groupIds,
    );
    final localVersionMap = {
      for (var v in localVersions)
        (v['groupId'] as String): (v['version'] as int),
    };

    // 过滤出需要更新的群组，并使用本地版本号
    final List<IGroupVersionSyncItem> needUpdateGroups = [];
    for (var groupVersion in groupVersions) {
      final localVersion = localVersionMap[groupVersion.groupId] ?? 0;
      if (localVersion < groupVersion.version) {
        needUpdateGroups.add(
          IGroupVersionSyncItem(
            groupId: groupVersion.groupId,
            version: localVersion,
          ),
        );
      }
    }

    return needUpdateGroups;
  }

  /// 同步群资料数据
  Future<void> _syncGroupData(
    GroupService groupService,
    GroupSyncStatusService syncStatusService,
    List<IGroupVersionSyncItem> groupsWithVersions,
  ) async {
    if (groupsWithVersions.isEmpty) return;

    // 直接使用传入的群组版本信息构造请求
    final response = await groupSyncApi(
      IGroupSyncReq(groups: groupsWithVersions),
    );
    if (response.code == 0 &&
        response.result != null &&
        response.result!.groups.isNotEmpty) {
      for (final group in response.result!.groups) {
        await groupService.upsert(
          GroupsCompanion(
            groupId: Value(group.groupId),
            title: Value(group.title),
            avatar: Value(group.avatar),
            creatorId: Value(group.creatorId),
            joinType: Value(group.joinType),
            status: Value(group.status),
            notice: Value(group.notice),
            version: Value(group.version),
            createdAt: Value(group.createdAt),
            updatedAt: Value(group.updatedAt),
          ),
        );

        // 更新本地群组版本状态
        await syncStatusService.upsertSyncStatus(
          module: 'info',
          groupId: group.groupId,
          version: group.version,
        );
      }

      getIt<GroupBusiness>().notifyGroupUpdate(
        response.result!.groups.map((g) => g.groupId).toList(),
      );
      getIt<ConversationBusiness>().notifyConversationUpdate();
    }
  }
}

final groupSync = GroupSync();
