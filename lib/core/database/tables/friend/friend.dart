import 'package:drift/drift.dart';

/// 好友表 (与 PC tables/friend/friend.ts 一致)
class Friends extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get friendId => text().named('friend_id')();
  TextColumn get sendUserId => text().named('send_user_id')();
  TextColumn get revUserId => text().named('rev_user_id')();
  TextColumn get sendUserNotice => text().named('send_user_notice').nullable()();
  TextColumn get revUserNotice => text().named('rev_user_notice').nullable()();
  TextColumn get source => text().named('source').nullable()();
  IntColumn get isDeleted => integer().named('is_deleted').withDefault(const Constant(0))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (friend_id)'];
}
