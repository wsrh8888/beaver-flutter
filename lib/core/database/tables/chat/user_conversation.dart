import 'package:drift/drift.dart';

/// 用户会话表 (与 PC tables/chat/user-conversation.ts 一致)
class ChatUserConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get conversationId => text().named('conversation_id')();
  IntColumn get isHidden => integer().named('is_hidden').withDefault(const Constant(0))();
  IntColumn get isPinned => integer().named('is_pinned').withDefault(const Constant(0))();
  IntColumn get isMuted => integer().named('is_muted').withDefault(const Constant(0))();
  IntColumn get userReadSeq => integer().named('user_read_seq').withDefault(const Constant(0))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();
}
