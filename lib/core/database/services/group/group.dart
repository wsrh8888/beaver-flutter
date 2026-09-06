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

final _logger = Logger('db-group-group');

class GroupService extends BaseService {
  const GroupService();

  /// 创建群组
  Future<void> create(GroupsCompanion group) async {
    try {

    await db.into(db.groups).insert(group);
    } catch (e, st) {
      _logger.warn({'text':'GroupService.create 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 创建或更新群组（upsert操作）
  Future<void> upsert(GroupsCompanion group) async {
    try {

    await db.into(db.groups).insert(
          group,
          mode: InsertMode.insertOrReplace,
        );
    } catch (e, st) {
      _logger.warn({'text':'GroupService.upsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量创建群组（支持插入或更新）
  Future<void> batchCreate(List<IGroupSyncItem> groups) async {
    try {
    _logger.info({'text':'GroupService.batchCreate 开始执行','data':{}});

    if (groups.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final group in groups) {
        batch.insert(
          db.groups,
          GroupsCompanion(
            groupId: Value(group.groupId),
            title: Value(group.title),
            avatar: Value(group.avatar),
            creatorId: Value(group.creatorId),
            joinType: Value(group.joinType),
            status: Value(group.status),
            version: Value(group.version),
            createdAt: Value(group.createdAt),
            updatedAt: Value(group.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
    } catch (e, st) {
      _logger.warn({'text':'GroupService.batchCreate 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 批量插入或更新群组（基于版本号判断是否需要更新）
  Future<void> batchUpsert(List<IGroupSyncItem> groups) async {
    try {
    _logger.info({'text':'GroupService.batchUpsert 开始执行','data':{}});

    if (groups.isEmpty) {
      return;
    }

    for (final group in groups) {
      // 获取本地群组数据
      final localGroup = await getGroupById(group.groupId);

      // 如果本地不存在或版本号不同，则更新
      if (localGroup == null || localGroup.version != group.version) {
        await upsert(GroupsCompanion(
          groupId: Value(group.groupId),
          title: Value(group.title),
          avatar: Value(group.avatar),
          creatorId: Value(group.creatorId),
          joinType: Value(group.joinType),
          status: Value(group.status),
          version: Value(group.version),
          createdAt: group.createdAt != null ? Value(group.createdAt!) : const Value.absent(),
          updatedAt: group.updatedAt != null ? Value(group.updatedAt!) : const Value.absent(),
        ));
      }
    }
    } catch (e, st) {
      _logger.warn({'text':'GroupService.batchUpsert 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据群组ID获取群组信息
  Future<Group?> getGroupById(String groupId) async {
    try {

    return (db.select(db.groups)..where((t) => t.groupId.equals(groupId))).getSingleOrNull();
    } catch (e, st) {
      _logger.warn({'text':'GroupService.getGroupById 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 根据群组ID列表批量获取群组信息
  Future<List<Group>> getGroupsByIds(List<String> groupIds) async {
    try {

    if (groupIds.isEmpty) {
      return [];
    }
    return (db.select(db.groups)..where((t) => t.groupId.isIn(groupIds))).get();
    } catch (e, st) {
      _logger.warn({'text':'GroupService.getGroupsByIds 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 获取当前用户的有效群组列表
  Future<List<Group>> getActiveGroups() async {
    try {

    return (db.select(db.groups)
          ..where((t) => t.status.equals(1))
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
    } catch (e, st) {
      _logger.warn({'text':'GroupService.getActiveGroups 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 更新群组信息
  Future<void> updateGroup(String groupId, Map<String, dynamic> updateData) async {
    try {

    updateData['updatedAt'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final companion = GroupsCompanion(
      title: updateData.containsKey('title') ? Value(updateData['title'] as String) : const Value.absent(),
      avatar: updateData.containsKey('avatar') ? Value(updateData['avatar'] as String) : const Value.absent(),
      notice: updateData.containsKey('notice') ? Value(updateData['notice'] as String?) : const Value.absent(),
      joinType: updateData.containsKey('joinType') ? Value(updateData['joinType'] as int) : const Value.absent(),
      status: updateData.containsKey('status') ? Value(updateData['status'] as int) : const Value.absent(),
      updatedAt: Value(updateData['updatedAt'] as int),
    );

    await (db.update(db.groups)..where((t) => t.groupId.equals(groupId))).write(companion);
    } catch (e, st) {
      _logger.warn({'text':'GroupService.updateGroup 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 删除群组
  Future<void> deleteGroup(String groupId) async {
    try {

    await (db.delete(db.groups)..where((t) => t.groupId.equals(groupId))).go();
    } catch (e, st) {
      _logger.warn({'text':'GroupService.deleteGroup 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
