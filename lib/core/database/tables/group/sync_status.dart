import 'package:drift/drift.dart';

/// 群组同步状态表 (与 PC tables/group/sync-status.ts 一致)
class GroupSyncStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().named('group_id')();
  TextColumn get module => text().named('module')();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (group_id, module)'];
}
