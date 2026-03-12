import 'package:drift/drift.dart';

/// 好友验证表 (与 PC tables/friend/friend_verify.ts 一致)
class FriendVerifies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get verifyId => text().named('verify_id')();
  TextColumn get sendUserId => text().named('send_user_id')();
  TextColumn get revUserId => text().named('rev_user_id')();
  IntColumn get sendStatus => integer().named('send_status').withDefault(const Constant(0))();
  IntColumn get revStatus => integer().named('rev_status').withDefault(const Constant(0))();
  TextColumn get message => text().named('message').nullable()();
  TextColumn get source => text().named('source').nullable()();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (verify_id)'];
}
