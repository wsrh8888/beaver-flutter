import 'package:drift/drift.dart';

/// 聊天同步状态表 (与 PC tables/chat/sync-status.ts 一致)
class ChatSyncStatus extends Table {
  TextColumn get conversationId => text().named('conversation_id')();
  TextColumn get module => text().named('module')();
  IntColumn get seq => integer().named('seq').withDefault(const Constant(0))();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {conversationId, module};
}

