import 'package:drift/drift.dart';

/// 用户表 (与 PC tables/user/user.ts 一致)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get nickName => text().named('nick_name')();
  TextColumn get email => text().named('email').nullable()();
  TextColumn get phone => text().named('phone').nullable()();
  TextColumn get avatar => text().named('avatar').nullable()();
  TextColumn get abstract => text().named('abstract').nullable()();
  IntColumn get gender => integer().named('gender').withDefault(const Constant(3))();
  IntColumn get userType => integer().named('user_type').withDefault(const Constant(1))(); // 1普通用户 2bot 3robot
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (user_id)'];
}
