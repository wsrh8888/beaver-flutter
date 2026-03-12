import 'package:drift/drift.dart';

/// 聊天消息表 (与 PC tables/chat/message.ts 一致)
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().named('message_id')();
  TextColumn get conversationId => text().named('conversation_id')();
  IntColumn get conversationType => integer().named('conversation_type')();
  IntColumn get seq => integer().named('seq').withDefault(const Constant(0))();
  TextColumn get sendUserId => text().named('send_user_id').nullable()();
  IntColumn get msgType => integer().named('msg_type')();
  TextColumn get targetMessageId => text().named('target_message_id').nullable()();
  TextColumn get msgPreview => text().named('msg_preview').nullable()();
  TextColumn get msg => text().named('msg').nullable()();
  IntColumn get sendStatus => integer().named('send_status').withDefault(const Constant(1))();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (message_id)'];
}
