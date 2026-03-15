import 'package:drift/drift.dart';

import 'tables/index.dart';

part 'app_database.g.dart';

/// 组装所有表，生成 Drift 数据库类 (与 PC init 后 drizzle 使用方式对应)
@DriftDatabase(
  tables: [
    Users,
    UserSyncStatus,
    Chats,
    ChatConversations,
    ChatUserConversations,
    ChatSyncStatus,
    Friends,
    FriendVerifies,
    Groups,
    GroupMembers,
    GroupJoinRequests,
    GroupSyncStatus,
    Datasync,
    Emojis,
    NotificationEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Version 1 -> 2 changes
          await _addColumnSafely(m, chatConversations, chatConversations.title);
          await _addColumnSafely(m, chatConversations, chatConversations.avatar);
          await _addColumnSafely(m, groupMembers, groupMembers.nickName);
          await _addColumnSafely(m, groupMembers, groupMembers.avatar);
        }
        if (from < 3) {
          // Version 2 -> 3 changes
          await m.createTable(emojis);
          await m.createTable(notificationEvents);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.createdAt);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.updatedAt);
        }
        if (from < 4) {
          // Version 3 -> 4: Ensure all columns from v2 and v3 are actually there
          // especially if the user was on v3 without these columns.
          await _addColumnSafely(m, chatConversations, chatConversations.title);
          await _addColumnSafely(m, chatConversations, chatConversations.avatar);
          await _addColumnSafely(m, groupMembers, groupMembers.nickName);
          await _addColumnSafely(m, groupMembers, groupMembers.avatar);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.createdAt);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.updatedAt);
          
          // Also ensure new tables exist
          try { await m.createTable(emojis); } catch(_) {}
          try { await m.createTable(notificationEvents); } catch(_) {}
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          print('[Database] Database created successfully');
        } else if (details.hadUpgrade) {
          print('[Database] Database upgraded from ${details.versionBefore} to ${details.versionNow}');
        }
      },
    );
  }

  /// 安全地添加列，如果列已存在则忽略错误
  Future<void> _addColumnSafely(Migrator m, dynamic table, GeneratedColumn column) async {
    try {
      await m.addColumn(table, column);
    } catch (e) {
      print('[Migration] Add column ${column.name} failed (possibly already exists): $e');
    }
  }
}
