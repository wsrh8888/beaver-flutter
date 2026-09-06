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

import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-friend-friend_verify');

class FriendVerifyService extends BaseService {
  const FriendVerifyService();

  /// 根据验证记录ID批量查询好友验证记录
  Future<Map<String, FriendVerify>> getFriendVerifiesByIds(
    List<String> verifyIds,
  ) async {
    try {

    if (verifyIds.isEmpty) {
      return {};
    }

    final existingVerifies = await (db.select(
      db.friendVerifies,
    )..where((t) => t.verifyId.isIn(verifyIds))).get();

    final verifyMap = <String, FriendVerify>{};
    for (final verify in existingVerifies) {
      verifyMap[verify.verifyId] = verify;
    }

    return verifyMap;
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.getFriendVerifiesByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建好友验证记录（支持插入或更新）
  Future<void> batchCreate(List<FriendVerifiesCompanion> verifies) async {
    try {
    _logger.info({'text':'FriendVerifyService.batchCreate 开始执行','data':{}});

    if (verifies.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final verify in verifies) {
        batch.insert(
          db.friendVerifies,
          verify,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取好友验证列表
  Future<List<FriendVerify>> getValidList(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {

    final offset = (page - 1) * limit;

    // 查询发送给当前用户的验证记录或当前用户发送的验证记录
    var query = db.select(db.friendVerifies)
      ..where((t) => t.revUserId.equals(userId) | t.sendUserId.equals(userId))
      ..limit(limit, offset: offset);

    return query.get();
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.getValidList 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据版本范围获取验证列表
  Future<List<FriendVerify>> getValidByVerRange(
    String userId, {
    int startVersion = 0,
    int endVersion = 9223372036854775807,
  }) async {
    try {

    // 查询指定版本范围内的验证记录
    return (db.select(db.friendVerifies)..where(
          (t) =>
              (t.revUserId.equals(userId) | t.sendUserId.equals(userId)) &
              t.version.isBiggerOrEqualValue(startVersion) &
              t.version.isSmallerOrEqualValue(endVersion),
        ))
        .get();
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.getValidByVerRange 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据验证记录ID列表批量查询验证记录
  Future<List<FriendVerify>> getValidByIds(List<String> verifyIds) async {
    try {

    if (verifyIds.isEmpty) {
      return [];
    }

    return (db.select(
      db.friendVerifies,
    )..where((t) => t.verifyId.isIn(verifyIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.getValidByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取未读（待处理）申请数
  Future<int> getUnreadCount(String userId) async {
    try {

    final query = db.selectOnly(db.friendVerifies)
      ..addColumns([db.friendVerifies.id.count()])
      ..where(
        db.friendVerifies.revUserId.equals(userId) &
            db.friendVerifies.revStatus.equals(0),
      );
    final result = await query
        .map((row) => row.read<int>(db.friendVerifies.id.count()))
        .getSingle();
    return result ?? 0;
    } catch (e, st) {
      _logger.warn({'text':'FriendVerifyService.getUnreadCount 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
