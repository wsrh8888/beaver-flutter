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
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-friend-verify');

/// 好友验证数据同步模块
class FriendVerifySyncModule {
  String _syncStatus = 'PENDING';

  /// 检查并同步
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) {
      _logger.warn({'text': '好友验证数据同步跳过：未登录（userId 为空）'});
      return;
    }
    _logger.info({'text': '开始同步好友验证数据'});

    try {
      final datasyncService = getIt<DatasyncService>();
      final friendVerifyService = getIt<FriendVerifyService>();

      // 获取本地同步游标（version=-1 表示发现全部变更，对齐 PC）
      final localCursor = await datasyncService.get('friend_verifies');
      final lastSyncVersion = localCursor?.version ?? 0;

      // 获取服务器上变更的好友验证版本信息
      final serverResponse = await datasyncGetSyncFriendVerifiesApi(
        IGetSyncFriendVerifiesReq(since: lastSyncVersion),
      );
      if (serverResponse.code != 0 || serverResponse.result == null) {
        _logger.warn({'text': '获取好友验证版本变更失败', 'data': {'code': serverResponse.code, 'msg': serverResponse.msg}});
        return;
      }

      final friendVerifyVersions = serverResponse.result!.friendVerifyVersions;
      final serverTimestamp = serverResponse.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的数据
      final needUpdateUuids = await _compareAndFilterFriendVerifyVersions(
        friendVerifyService,
        friendVerifyVersions,
      );
      _logger.info({'text': '好友验证数据对比完成', 'data': {'needUpdate': needUpdateUuids.length}});

      if (needUpdateUuids.isNotEmpty) {
        // 有需要更新的好友验证数据
        await _syncFriendVerifyData(friendVerifyService, needUpdateUuids);

        // 从变更的数据中找到最大的版本号
        int maxVersion = 0;
        for (var item in friendVerifyVersions) {
          if (item.version > maxVersion) maxVersion = item.version;
        }

        await _updateFriendVerifiesCursor(
          datasyncService,
          maxVersion,
          serverTimestamp,
        );
      } else {
        // 没有需要更新的数据，直接更新时间戳
        await _updateFriendVerifiesCursor(
          datasyncService,
          localCursor?.version ?? 0, // 保持原有最高版本号
          serverTimestamp,
        );
      }

      _syncStatus = 'COMPLETED';
      _logger.info({'text': '好友验证数据同步完成'});
    } catch (error) {
      _syncStatus = 'FAILED';
      _logger.warn({'text': '好友验证数据同步异常', 'data': {'error': error.toString()}});
    }
  }

  /// 对比本地数据，过滤出需要更新的好友验证ID
  Future<List<String>> _compareAndFilterFriendVerifyVersions(
    FriendVerifyService friendVerifyService,
    List<IFriendVerifyVersionItem> friendVerifyVersions,
  ) async {
    if (friendVerifyVersions.isEmpty) return [];

    // 提取所有变更的好友验证ID
    final verifyIds = friendVerifyVersions
        .map((item) => item.verifyId)
        .where((id) => id.trim().isNotEmpty)
        .toList();
    if (verifyIds.isEmpty) return [];

    // 查询本地已存在的记录
    final existingVerifiesMap = await friendVerifyService
        .getFriendVerifiesByIds(verifyIds);

    // 过滤出需要更新的 ID
    final List<String> needUpdateVerifyIds = [];
    for (var id in verifyIds) {
      final existingVerify = existingVerifiesMap[id];
      final serverVersion = friendVerifyVersions
          .firstWhere((item) => item.verifyId == id)
          .version;

      if (existingVerify == null || existingVerify.version < serverVersion) {
        needUpdateVerifyIds.add(id);
      }
    }

    return needUpdateVerifyIds;
  }

  /// 同步好友验证数据
  Future<void> _syncFriendVerifyData(
    FriendVerifyService friendVerifyService,
    List<String> verifyIds,
  ) async {
    if (verifyIds.isEmpty) return;

    // 分批获取好友验证数据
    const batchSize = 50;
    for (int i = 0; i < verifyIds.length; i += batchSize) {
      final batchVerifyIds = verifyIds.sublist(
        i,
        (i + batchSize > verifyIds.length) ? verifyIds.length : i + batchSize,
      );

      final response = await getFriendVerifiesListByIdsApi(
        IGetFriendVerifiesListByIdsReq(verifyIds: batchVerifyIds),
      );
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '批量获取好友验证数据失败', 'data': {'code': response.code, 'msg': response.msg, 'batchCount': batchVerifyIds.length}});
        continue;
      }
      if (response.result!.friendVerifies.isNotEmpty) {
        final friendVerifies = response.result!.friendVerifies
            .map(
              (verify) => FriendVerifiesCompanion(
                verifyId: Value(verify.verifyId),
                sendUserId: Value(verify.sendUserId),
                revUserId: Value(verify.revUserId),
                sendStatus: Value(verify.sendStatus),
                revStatus: Value(verify.revStatus),
                message: Value(verify.message),
                source: Value(verify.source),
                version: Value(verify.version),
                createdAt: Value(verify.createdAt),
                updatedAt: Value(verify.updatedAt),
              ),
            )
            .toList();

        await friendVerifyService.batchCreate(friendVerifies);
        // TODO: 发送通知到渲染进程
      }
    }
  }

  /// 更新游标
  Future<void> _updateFriendVerifiesCursor(
    DatasyncService datasyncService,
    int? version,
    int updatedAt,
  ) async {
    await datasyncService.upsert('friend_verifies', version, updatedAt);
  }

  String getStatus() => _syncStatus;
}

final friendVerifySyncModule = FriendVerifySyncModule();
