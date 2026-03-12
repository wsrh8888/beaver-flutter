import 'package:drift/drift.dart';

/// 群组表 (与 PC tables/group/groups.ts 一致)
class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().named('group_id')();
  IntColumn get type => integer().named('type').withDefault(const Constant(1))();
  TextColumn get title => text().named('title')();
  TextColumn get avatar => text().named('avatar').withDefault(const Constant('a9de5548bef8c10b92428fff61275c72.png'))();
  TextColumn get creatorId => text().named('creator_id')();
  TextColumn get notice => text().named('notice').nullable()();
  IntColumn get joinType => integer().named('join_type').withDefault(const Constant(0))();
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (group_id)'];
}
