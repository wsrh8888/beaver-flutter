import 'package:drift/drift.dart';

// 媒体表
class MediaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text().unique()();
  TextColumn get md5 => text().nullable()();
  TextColumn get path => text()();
  TextColumn get type => text()();
  IntColumn get size => integer().nullable()();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}
