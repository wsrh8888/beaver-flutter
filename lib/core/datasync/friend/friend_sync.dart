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
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-friend');

/// 好友数据同步模块
class FriendSyncModule {
  String _syncStatus = 'PENDING';

  /// 检查并同步
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) {
      _logger.warn({'text': '好友数据同步跳过：未登录（userId 为空）'});
      return;
    }
    _logger.info({'text': '开始同步好友数据'});

    try {
      final datasyncService = getIt<DatasyncService>();
      final friendService = getIt<FriendService>();

      // 获取本地同步游标（version=-1 表示发现全部变更，对齐 PC）
      final localCursor = await datasyncService.get('friends');
      final lastSyncVersion = localCursor?.version ?? 0;

      // 获取服务器上变更的好友版本信息
      final response = await datasyncGetSyncFriendsApi(
        IGetSyncFriendsReq(since: lastSyncVersion),
      );
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '获取好友版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
        return;
      }

      final friendVersions = response.result!.friendVersions;
      final serverTimestamp = response.result!.serverTimestamp;

      // 对比本地数据，过滤出需要更新的数据
      final needUpdateFriendshipIds = await _compareAndFilterFriendVersions(
        friendService,
        friendVersions,
      );
      _logger.info({'text': '好友数据对比完成', 'data': {'needUpdate': needUpdateFriendshipIds.length}});

      if (needUpdateFriendshipIds.isNotEmpty) {
        // 有需要更新的好友数据
        await _syncFriendData(friendService, needUpdateFriendshipIds);
        getIt<FriendBusiness>().notifyFriendUpdate(needUpdateFriendshipIds);

        // 从变更的数据中找到最大的版本号
        int maxVersion = 0;
        for (var item in friendVersions) {
          if (item.version > maxVersion) maxVersion = item.version;
        }

        await _updateFriendsCursor(
          datasyncService,
          maxVersion,
          serverTimestamp,
        );
      } else {
        // 没有需要更新的数据，直接更新时间戳
        await _updateFriendsCursor(datasyncService, null, serverTimestamp);
      }

      _syncStatus = 'COMPLETED';
      _logger.info({'text': '好友数据同步完成'});
    } catch (error) {
      _syncStatus = 'FAILED';
      _logger.warn({'text': '好友数据同步异常', 'data': {'error': error.toString()}});
    }
  }

  /// 对比本地数据，过滤出需要更新的好友关系ID
  Future<List<String>> _compareAndFilterFriendVersions(
    FriendService friendService,
    List<IFriendVersionItem> friendVersions,
  ) async {
    if (friendVersions.isEmpty) return [];

    // 提取所有变更的好友关系ID
    final friendshipIds = friendVersions
        .map((item) => item.friendId)
        .where((id) => id.trim().isNotEmpty)
        .toList();
    if (friendshipIds.isEmpty) return [];

    // 查询本地已存在的记录
    final existingFriends = await friendService.getFriendRecordsByIds(
      friendshipIds,
    );
    final existingFriendsMap = {for (var f in existingFriends) f.friendId: f};

    // 过滤出需要更新的 friendshipIds
    final List<String> needUpdateFriendshipIds = [];
    for (var id in friendshipIds) {
      final existingFriend = existingFriendsMap[id];
      final serverVersion = friendVersions
          .firstWhere((item) => item.friendId == id)
          .version;

      if (existingFriend == null || existingFriend.version < serverVersion) {
        needUpdateFriendshipIds.add(id);
      }
    }

    return needUpdateFriendshipIds;
  }

  /// 同步好友数据
  Future<void> _syncFriendData(
    FriendService friendService,
    List<String> friendshipIds,
  ) async {
    if (friendshipIds.isEmpty) return;

    // 分批获取好友数据
    const batchSize = 50;
    for (int i = 0; i < friendshipIds.length; i += batchSize) {
      final batchIds = friendshipIds.sublist(
        i,
        (i + batchSize > friendshipIds.length)
            ? friendshipIds.length
            : i + batchSize,
      );

      final response = await getFriendsListByIdsApi(
        IGetFriendsListByIdsReq(friendIds: batchIds),
      );
      if (response.code != 0 || response.result == null) {
        _logger.warn({'text': '批量获取好友数据失败', 'data': {'code': response.code, 'msg': response.msg, 'batchCount': batchIds.length}});
        continue;
      }
      if (response.result!.friends.isNotEmpty) {
        final companions = response.result!.friends
            .map((f) => f.toCompanion())
            .toList();
        await friendService.batchCreate(companions);
        // TODO: 发送通知到渲染进程
      }
    }
  }

  /// 更新游标
  Future<void> _updateFriendsCursor(
    DatasyncService datasyncService,
    int? version,
    int updatedAt,
  ) async {
    await datasyncService.upsert('friends', version, updatedAt);
  }

  String getStatus() => _syncStatus;
}

final friendSyncModule = FriendSyncModule();
