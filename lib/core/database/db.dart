import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:beaver/core/cache/index.dart'; // 添加缓存管理导入
import 'tables/user/user.dart';
import 'tables/user/sync_status.dart';
import 'tables/chat/message.dart';
import 'tables/chat/conversation.dart';
import 'tables/chat/user_conversation.dart';
import 'tables/chat/sync_status.dart';
import 'tables/friend/friend.dart';
import 'tables/friend/friend_verify.dart';
import 'tables/group/groups.dart';
import 'tables/group/members.dart';
import 'tables/group/join_requests.dart';
import 'tables/group/sync_status.dart';
import 'tables/datasync/datasync.dart';
import 'tables/emoji/emoji.dart';
import 'tables/emoji/collect.dart';
import 'tables/emoji/package.dart';
import 'tables/emoji/package_collect.dart';
import 'tables/emoji/package_emoji.dart';
import 'tables/media/media.dart';
import 'tables/notification/event.dart';
import 'tables/notification/inbox.dart';
import 'tables/notification/read.dart';

part 'db.g.dart';

/// 数据库核心定义
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
    EmojiCollectTable,
    EmojiPackageTable,
    EmojiPackageCollectTable,
    EmojiPackageEmojiTable,
    MediaTable,
    NotificationEvents,
    NotificationInboxTable,
    NotificationReadTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
    );
  }

  /// 清除本地所有数据 (用于 设置-清理数据)
  Future<void> clearAllData() async {
    await transaction(() async {
      // allTables 是 Drift 自动生成的包含所有表的列表
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

/// 数据库连接管理 (与 PC db.ts DBManager 一致：按 userId 分库、init/close)
class DatabaseManager {
  static AppDatabase? _instance;
  static String? _currentUserId;

  static AppDatabase get instance {
    if (_instance == null) {
      throw StateError('Database not initialized. Call init(userId) first.');
    }
    return _instance!;
  }

  static String? get currentUserId => _currentUserId;

  static Future<void> init(String userId) async {
    if (_instance != null && _currentUserId == userId) return;

    await close();

    final dbFolder = await getApplicationDocumentsDirectory();
    // 使用大厂规范：对标 config.dart 的隔离路径
    final userDbPath = p.join(
      dbFolder.path,
      CachePathConfig.userDbRoot(userId),
    );
    final userFolder = Directory(userDbPath);
    if (!await userFolder.exists()) {
      await userFolder.create(recursive: true);
    }

    final file = File(p.join(userFolder.path, 'database.db'));
    _instance = AppDatabase(_openConnection(file));
    _currentUserId = userId;

    // 同步初始化缓存管理 (UserId 同步)
    await mediaManager.init(userId);
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
    _currentUserId = null;
  }
}

LazyDatabase _openConnection(File file) {
  return LazyDatabase(() async {
    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path;
    return NativeDatabase.createInBackground(file);
  });
}
