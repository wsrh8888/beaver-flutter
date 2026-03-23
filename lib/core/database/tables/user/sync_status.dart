import 'package:drift/drift.dart';

/// 用户同步状态表 (与 PC tables/user/sync-status.ts 一致)
class UserSyncStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  IntColumn get userVersion => integer().named('user_version').withDefault(const Constant(0))();
  IntColumn get lastSyncTime => integer().named('last_sync_time').withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();
}
