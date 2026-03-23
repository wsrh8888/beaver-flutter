import 'package:drift/drift.dart';

/// 入群申请表 (与 PC tables/group/join-requests.ts 一致)
class GroupJoinRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().named('group_id')();
  TextColumn get applicantUserId => text().named('applicant_user_id')();
  TextColumn get message => text().named('message').nullable()();
  IntColumn get status => integer().named('status').withDefault(const Constant(0))();
  TextColumn get handledBy => text().named('handled_by').nullable()();
  IntColumn get handledAt => integer().named('handled_at').nullable()();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();
}
