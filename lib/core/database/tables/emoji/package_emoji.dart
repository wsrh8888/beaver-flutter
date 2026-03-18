import 'package:drift/drift.dart';

// 表情包与表情的多对多关联表
class EmojiPackageEmojiTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get relationId => text().unique()();
  TextColumn get packageId => text()();
  TextColumn get emojiId => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
