import 'package:drift/drift.dart';

// 通知已读游标：按用户+分类记录查看时间
class NotificationReadTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get category => text()();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get lastReadAt => integer().nullable()();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
