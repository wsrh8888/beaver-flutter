import 'package:drift/drift.dart';

/// 会话元数据表 (与 PC tables/chat/conversation.ts 一致)
class ChatConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId => text().named('conversation_id')();
  IntColumn get type => integer().named('type')();
  TextColumn get title => text().named('title').nullable()();
  TextColumn get avatar => text().named('avatar').nullable()();
  IntColumn get maxSeq => integer().named('max_seq').withDefault(const Constant(0))();
  TextColumn get lastMessage => text().named('last_message').nullable()();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (conversation_id)'];
}
