import 'package:drift/drift.dart';

// 通知收件箱：用户维度存储事件状态
class NotificationInboxTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get eventId => text()();
  TextColumn get eventType => text()();
  TextColumn get category => text()();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get isRead => integer().withDefault(const Constant(0))();
  IntColumn get readAt => integer().nullable()();
  IntColumn get status => integer().withDefault(const Constant(1))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  IntColumn get silent => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
