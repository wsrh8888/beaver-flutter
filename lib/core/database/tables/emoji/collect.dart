import 'package:drift/drift.dart';

// 用户收藏的表情表
class EmojiCollectTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get emojiCollectId => text().unique()();
  TextColumn get userId => text()();
  TextColumn get emojiId => text()();
  TextColumn get packageId => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
}
