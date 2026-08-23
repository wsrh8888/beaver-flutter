/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:beaver/core/cache/index.dart';
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
import 'tables/circle/circles.dart';
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
    Circles,
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _createChatMessageMediasTable(m.database);
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await _createChatMessageMediasTable(m.database);
        }
        if (from < 3) {
          await m.createTable(circles);
        }
      },
    );
  }

  static Future<void> _createChatMessageMediasTable(GeneratedDatabase database) async {
    await database.customStatement('''
      CREATE TABLE IF NOT EXISTS chat_message_medias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        message_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL DEFAULT 0,
        UNIQUE (user_id, message_id)
      )
    ''');
  }

  /// 清除本地所有数据 (用于 设置-清理数据)
  Future<void> clearAllData() async {
    await transaction(() async {
      // allTables 是 Drift 自动生成的包含所有表的列表
      for (final table in allTables) {
        await delete(table).go();
      }
      await customStatement('DELETE FROM chat_message_medias');
    });
  }
}

/// 数据库连接管理 (与 PC db.ts DBManager 一致：按 userId 分库、init/close)
class DatabaseManager {
  static AppDatabase? _instance;
  static String? _currentUserId;
  static Future<void>? _initFuture;

  static AppDatabase get instance {
    if (_instance == null) {
      throw StateError('Database not initialized. Call init(userId) first.');
    }
    return _instance!;
  }

  static String? get currentUserId => _currentUserId;

  static Future<void> init(String userId) async {
    if (_instance != null && _currentUserId == userId) return;

    if (_initFuture != null) {
      await _initFuture;
      if (_instance != null && _currentUserId == userId) return;
    }

    _initFuture = _doInit(userId);
    try {
      await _initFuture;
    } finally {
      _initFuture = null;
    }
  }

  static Future<void> _doInit(String userId) async {
    await close();

    final dbFolder = await getApplicationDocumentsDirectory();
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

    await mediaManager.init(userId);
  }

  static Future<void> close() async {
    if (_instance == null) return;

    final closing = _instance!;
    _instance = null;
    _currentUserId = null;
    await closing.close();
  }
}

LazyDatabase _openConnection(File file) {
  return LazyDatabase(() async {
    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path;
    return NativeDatabase.createInBackground(file);
  });
}
