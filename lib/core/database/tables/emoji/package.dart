import 'package:drift/drift.dart';

// 表情包表
class EmojiPackageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageId => text().unique()();
  TextColumn get title => text()();
  TextColumn get coverFile => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();
  IntColumn get status => integer().withDefault(const Constant(1))();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
