import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'tables/index.dart';

part 'app_database.g.dart';

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
    CallHistoryTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  
  // 提供 instance 方便全局访问
  static AppDatabase get instance => DatabaseManager.instance;

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await _addColumnSafely(m, chatConversations, chatConversations.title);
          await _addColumnSafely(m, chatConversations, chatConversations.avatar);
          await _addColumnSafely(m, groupMembers, groupMembers.nickName);
          await _addColumnSafely(m, groupMembers, groupMembers.avatar);
        }
        if (from < 3) {
          await m.createTable(emojis);
          await m.createTable(notificationEvents);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.createdAt);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.updatedAt);
        }
        if (from < 4) {
          await _addColumnSafely(m, chatConversations, chatConversations.title);
          await _addColumnSafely(m, chatConversations, chatConversations.avatar);
          await _addColumnSafely(m, groupMembers, groupMembers.nickName);
          await _addColumnSafely(m, groupMembers, groupMembers.avatar);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.createdAt);
          await _addColumnSafely(m, chatUserConversations, chatUserConversations.updatedAt);
          try { await m.createTable(emojis); } catch(_) {}
          try { await m.createTable(notificationEvents); } catch(_) {}
        }
        if (from < 5) {
          // Version 5: Add call history table
          try { await m.createTable(callHistoryTable); } catch(_) {}
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

  Future<void> _addColumnSafely(Migrator m, dynamic table, GeneratedColumn column) async {
    try {
      await m.addColumn(table, column);
    } catch (e) {
      print('[Migration] Add column ${column.name} failed: $e');
    }
  }
}
