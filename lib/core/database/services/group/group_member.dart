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
import 'package:beaver/types/api/group.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('db-group-group_member');

class GroupMemberService extends BaseService {
  const GroupMemberService();

  /// 创建或更新群成员（upsert操作）
  Future<void> upsert(GroupMembersCompanion member) async {
    try {

    await db.into(db.groupMembers).insert(
      member,
      mode: InsertMode.insertOrReplace,
    );
    } catch (e, st) {
      _logger.warn({'text':'GroupMemberService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建群成员（支持插入或更新）
  Future<void> batchCreate(List<GroupMembersCompanion> members) async {
    try {
    _logger.info({'text':'GroupMemberService.batchCreate 开始执行','data':{}});

    if (members.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final member in members) {
        batch.insert(
          db.groupMembers,
          member,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'GroupMemberService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建群成员（从API数据创建）
  Future<void> batchCreateFromApi(List<IGroupMemberSyncItem> members) async {
    try {
    _logger.info({'text':'GroupMemberService.batchCreateFromApi 开始执行','data':{}});

    if (members.isEmpty) {
      return;
    }

    final companions = members.map(
      (member) => GroupMembersCompanion(
        groupId: Value(member.groupId),
        userId: Value(member.userId),
        role: Value(member.role),
        status: Value(member.status),
        joinTime: Value(member.joinTime ~/ 1000),
        version: Value(member.version),
      ),
    ).toList();

    await batchCreate(companions);
    } catch (e, st) {
      _logger.warn({'text':'GroupMemberService.batchCreateFromApi 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取群成员列表（纯数据库查询，不含业务逻辑）
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {

    return (db.select(db.groupMembers)..where((t) => t.groupId.equals(groupId) & t.status.equals(1))).get();
    } catch (e, st) {
      _logger.warn({'text':'GroupMemberService.getGroupMembers 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取用户加入的群组成员记录（纯数据库查询，不含业务逻辑）
  Future<List<GroupMember>> getUserMemberships(String userId) async {
    try {

    return (db.select(db.groupMembers)..where((t) => t.userId.equals(userId) & t.status.equals(1))).get();
    } catch (e, st) {
      _logger.warn({'text':'GroupMemberService.getUserMemberships 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
