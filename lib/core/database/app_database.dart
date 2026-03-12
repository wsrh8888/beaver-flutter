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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;
}
