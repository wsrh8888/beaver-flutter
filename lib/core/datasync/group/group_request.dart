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
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-group-join-request');

/// 入群申请同步器
class GroupJoinRequestSync {
  /// 检查并同步入群申请数据
  Future<void> checkAndSync() async {
    _logger.info({'text': '开始同步入群申请数据'});
    try {
      final datasyncService = getIt<DatasyncService>();
      final groupJoinRequestService = getIt<GroupJoinRequestService>();
      final syncStatusService = getIt<GroupSyncStatusService>();

      // 获取本地同步游标（version=-1 表示按版本发现变更，对齐 PC）
      final cursor = await datasyncService.get('group_join_requests');
      final lastSyncVersion = cursor?.version ?? 0;

      // 获取服务器上变更的版本信息
      final response = await datasyncGetSyncGroupRequestsApi(
        IGetSyncGroupRequestsReq(since: lastSyncVersion),
      );
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '获取入群申请版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
        return;
      }

      // 对比过滤
      final needUpdateGroups = await _compareAndFilterRequestVersions(
        syncStatusService,
        response.result!.groupVersions,
      );
      _logger.info({'text': '入群申请数据对比完成', 'data': {'needUpdate': needUpdateGroups.length}});

      if (needUpdateGroups.isNotEmpty) {
        // 同步具体数据
        await _syncRequestData(
          groupJoinRequestService,
          syncStatusService,
          needUpdateGroups,
        );
      }

      // 更新游标
      await datasyncService.upsert(
        'group_join_requests',
        -1,
        response.result!.serverTimestamp,
      );
      _logger.info({'text': '入群申请数据同步完成'});
    } catch (error) {
      _logger.warn({'text': '入群申请同步异常', 'data': {'error': error.toString()}});
    }
  }

  /// 对比过滤版本
  Future<List<IGroupVersionSyncItem>> _compareAndFilterRequestVersions(
    GroupSyncStatusService syncStatusService,
    List<IGroupRequestsVersionItem> groupVersions,
  ) async {
    if (groupVersions.isEmpty) return [];

    final groupIds = groupVersions.map((item) => item.groupId).toList();
    final localVersions = await syncStatusService.getModuleVersions(
      'requests',
      groupIds,
    );
    final localVersionMap = {
      for (var v in localVersions)
        (v['groupId'] as String): (v['version'] as int),
    };

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

  /// 同步入群申请
  Future<void> _syncRequestData(
    GroupJoinRequestService groupJoinRequestService,
    GroupSyncStatusService syncStatusService,
    List<IGroupVersionSyncItem> groupsWithVersions,
  ) async {
    if (groupsWithVersions.isEmpty) return;

    final response = await groupJoinRequestSyncApi(
      IGroupJoinRequestSyncReq(groups: groupsWithVersions),
    );
    if (response.code != 0 || response.result == null) {
      _logger.warn({'text': '同步入群申请数据失败', 'data': {'code': response.code, 'msg': response.msg, 'groupCount': groupsWithVersions.length}});
      return;
    }
    if (response.result!.groupJoinRequests.isNotEmpty) {
      await groupJoinRequestService.batchCreate(
        response.result!.groupJoinRequests,
      );

      for (final req in response.result!.groupJoinRequests) {
        await syncStatusService.upsertSyncStatus(
          module: 'requests',
          groupId: req.groupId,
          version: req.version,
        );
      }
    }
  }
}

final groupJoinRequestSync = GroupJoinRequestSync();
