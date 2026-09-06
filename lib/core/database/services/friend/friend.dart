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

final _logger = Logger('db-friend-friend');

class FriendService extends BaseService {
  const FriendService();

  /// 根据 IDs 获取好友记录
  Future<List<Friend>> getFriendRecordsByIds(List<String> friendshipIds) async {
    try {

    return (db.select(
      db.friends,
    )..where((t) => t.friendId.isIn(friendshipIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'FriendService.getFriendRecordsByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取两个用户之间的好友关系
  Future<Friend?> getFriendByPeerId(String currentUserId, String peerId) async {
    try {

    final friends = await (db.select(db.friends)..where(
          (t) =>
              t.isDeleted.equals(0) &
              ((t.sendUserId.equals(currentUserId) &
                      t.revUserId.equals(peerId)) |
                  (t.sendUserId.equals(peerId) &
                      t.revUserId.equals(currentUserId))),
        ))
        .get();
    return friends.isNotEmpty ? friends.first : null;
    } catch (e, st) {
      _logger.warn({'text':'FriendService.getFriendByPeerId 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取所有好友列表
  Future<List<Friend>> getFriends() async {
    try {

    return (db.select(db.friends)..where((t) => t.isDeleted.equals(0))).get();
    } catch (e, st) {
      _logger.warn({'text':'FriendService.getFriends 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 删除好友 (本地标识删除)
  Future<void> deleteFriend(String friendId) async {
    try {

    await (db.update(db.friends)..where((t) => t.friendId.equals(friendId)))
        .write(const FriendsCompanion(isDeleted: Value(1)));
    } catch (e, st) {
      _logger.warn({'text':'FriendService.deleteFriend 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据 IDs 获取验证记录
  Future<List<FriendVerify>> getFriendVerifiesByIds(
    List<String> verifyIds,
  ) async {
    try {

    return (db.select(
      db.friendVerifies,
    )..where((t) => t.verifyId.isIn(verifyIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'FriendService.getFriendVerifiesByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建或更新好友
  Future<void> batchCreate(List<FriendsCompanion> friends) async {
    try {
    _logger.info({'text':'FriendService.batchCreate 开始执行','data':{}});

    await db.batch((batch) {
      for (final companion in friends) {
        batch.insert(db.friends, companion, mode: InsertMode.insertOrReplace);
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'FriendService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建或更新好友验证
  Future<void> batchCreateVerifies(
    List<FriendVerifiesCompanion> verifies,
  ) async {
    try {
    _logger.info({'text':'FriendService.batchCreateVerifies 开始执行','data':{}});

    await db.batch((batch) {
      for (final companion in verifies) {
        batch.insert(
          db.friendVerifies,
          companion,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'FriendService.batchCreateVerifies 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新好友备注
  Future<void> updateNotice(
    String friendId, {
    String? sendUserNotice,
    String? revUserNotice,
  }) async {
    try {

    await (db.update(db.friends)..where((t) => t.friendId.equals(friendId)))
        .write(
      FriendsCompanion(
        sendUserNotice: sendUserNotice != null
            ? Value(sendUserNotice)
            : const Value.absent(),
        revUserNotice: revUserNotice != null
            ? Value(revUserNotice)
            : const Value.absent(),
      ),
    );
    } catch (e, st) {
      _logger.warn({'text':'FriendService.updateNotice 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
