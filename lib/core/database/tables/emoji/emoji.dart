import 'package:drift/drift.dart';

class Emojis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get emojiId => text().named('emoji_id')();
  TextColumn get fileKey => text().named('file_key')();
  TextColumn get title => text().named('title')();
  TextColumn get emojiInfo => text().named('emoji_info').nullable()();
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (emoji_id)'];
}
