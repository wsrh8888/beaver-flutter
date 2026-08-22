import 'package:drift/drift.dart';

/// 圈子表（与 PC tables/circle/circles.ts 一致）
class Circles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get circleId => text().named('circle_id')();
  TextColumn get name => text().named('name')();
  TextColumn get avatar =>
      text().named('avatar').withDefault(const Constant(''))();
  TextColumn get description =>
      text().named('description').withDefault(const Constant(''))();
  TextColumn get creatorId =>
      text().named('creator_id').withDefault(const Constant(''))();
  IntColumn get memberCount =>
      integer().named('member_count').withDefault(const Constant(0))();
  IntColumn get role => integer().named('role').withDefault(const Constant(0))();
  IntColumn get joinType =>
      integer().named('join_type').withDefault(const Constant(0))();
  IntColumn get version =>
      integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (circle_id)'];
}
