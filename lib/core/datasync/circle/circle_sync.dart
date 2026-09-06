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

import 'package:beaver/api/circle.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-circle-sync');

/// 圈子资料同步（对齐 PC datasync/circle）
class CircleSync {
  Future<void> checkAndSync() async {
    _logger.info({'text': '开始同步圈子资料数据'});
    try {
      final datasyncService = getIt<DatasyncService>();
      final circleService = getIt<CircleService>();

      final cursor = await datasyncService.get('circles');
      final lastVersion = cursor?.version ?? 0;

      final serverResponse = await datasyncGetSyncCircleInfoApi(
        IGetSyncCircleInfoReq(since: lastVersion),
      );
      if (serverResponse.code != 0 || serverResponse.result == null) {
        _logger.warn({'text': '获取圈子版本变更失败', 'data': {'code': serverResponse.code, 'msg': serverResponse.msg}});
        return;
      }

      final circleVersions = serverResponse.result!.circleVersions;
      final needUpdate = await _compareAndFilter(circleService, circleVersions);
      _logger.info({'text': '圈子资料对比完成', 'data': {'needUpdate': needUpdate.length}});

      if (needUpdate.isNotEmpty) {
        await _syncCircleData(circleService, lastVersion);
      }

      final maxVersion = circleVersions.isNotEmpty
          ? circleVersions
              .map((e) => e.version)
              .fold<int>(lastVersion, (a, b) => a > b ? a : b)
          : lastVersion;

      await datasyncService.upsert(
        'circles',
        maxVersion,
        serverResponse.result!.serverTimestamp > 0
            ? (serverResponse.result!.serverTimestamp > 1000000000000
                ? serverResponse.result!.serverTimestamp ~/ 1000
                : serverResponse.result!.serverTimestamp)
            : (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      );
      _logger.info({'text': '圈子资料同步完成'});
    } catch (e) {
      _logger.warn({'text': '圈子资料同步异常', 'data': {'error': e.toString()}});
    }
  }

  Future<List<ICircleInfoVersionItem>> _compareAndFilter(
    CircleService circleService,
    List<ICircleInfoVersionItem> circleVersions,
  ) async {
    if (circleVersions.isEmpty) return [];

    final circleIds = circleVersions.map((e) => e.circleId).toList();
    final localCircles = await circleService.getCirclesByIds(circleIds);
    final localVersionMap = {
      for (final item in localCircles) item.circleId: item.version,
    };

    final needUpdate = <ICircleInfoVersionItem>[];
    for (final item in circleVersions) {
      final localVersion = localVersionMap[item.circleId] ?? 0;
      if (localVersion < item.version) {
        needUpdate.add(item);
      }
    }
    return needUpdate;
  }

  Future<void> _syncCircleData(
    CircleService circleService,
    int lastVersion,
  ) async {
    final response = await circleSyncApi(ICircleSyncReq(version: lastVersion));
    if (response.code != 0 ||
        response.result == null ||
        response.result!.list.isEmpty) {
      _logger.warn({'text': '同步圈子数据失败', 'data': {'code': response.code, 'msg': response.msg}});
      return;
    }

    await circleService.batchUpsert(response.result!.list);
    getIt<CircleBusiness>().notifyCircleUpdate(
      response.result!.list.map((e) => e.circleId).toList(),
    );
  }
}

final circleSync = CircleSync();
