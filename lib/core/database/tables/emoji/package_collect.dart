import 'package:drift/drift.dart';

// 用户收藏的表情包表
class EmojiPackageCollectTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageCollectId => text().unique()();
  TextColumn get userId => text()();
  TextColumn get packageId => text()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
