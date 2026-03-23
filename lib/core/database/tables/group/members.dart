import 'package:drift/drift.dart';

/// 群成员表 (与 PC tables/group/members.ts 一致)
class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().named('group_id')();
  TextColumn get userId => text().named('user_id')();
  TextColumn get nickName => text().named('nick_name').nullable()();
  TextColumn get avatar => text().named('avatar').nullable()();
  IntColumn get role => integer().named('role').withDefault(const Constant(3))();
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  IntColumn get joinTime => integer().named('join_time').nullable()();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (group_id, user_id)'];
}
