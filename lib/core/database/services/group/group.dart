import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:beaver/types/api/group.dart';

class GroupService extends BaseService {
  GroupService(super.db);

  /// 创建群组
  Future<void> create(GroupsCompanion group) async {
    await db.into(db.groups).insert(group);
  }

  /// 创建或更新群组（upsert操作）
  Future<void> upsert(GroupsCompanion group) async {
    await db.into(db.groups).insert(
          group,
          mode: InsertMode.insertOrReplace,
        );
  }

  /// 批量创建群组（支持插入或更新）
  Future<void> batchCreate(List<IGroupSyncItem> groups) async {
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
  }

  /// 批量插入或更新群组（基于版本号判断是否需要更新）
  Future<void> batchUpsert(List<IGroupSyncItem> groups) async {
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
  }

  /// 根据群组ID获取群组信息
  Future<Group?> getGroupById(String groupId) async {
    return (db.select(db.groups)..where((t) => t.groupId.equals(groupId))).getSingleOrNull();
  }

  /// 根据群组ID列表批量获取群组信息
  Future<List<Group>> getGroupsByIds(List<String> groupIds) async {
    if (groupIds.isEmpty) {
      return [];
    }
    return (db.select(db.groups)..where((t) => t.groupId.isIn(groupIds))).get();
  }

  /// 更新群组信息
  Future<void> updateGroup(String groupId, Map<String, dynamic> updateData) async {
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
  }

  /// 删除群组
  Future<void> deleteGroup(String groupId) async {
    await (db.delete(db.groups)..where((t) => t.groupId.equals(groupId))).go();
  }
}
