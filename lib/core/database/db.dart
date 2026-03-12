import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'app_database.dart';

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

  static Future<void> init(String userId) async {
    if (_instance != null && _currentUserId == userId) return;

    await close();

    final dbFolder = await getApplicationDocumentsDirectory();
    final userFolder = Directory(p.join(dbFolder.path, 'users', userId));
    if (!await userFolder.exists()) {
      await userFolder.create(recursive: true);
    }

    final file = File(p.join(userFolder.path, 'database.db'));
    _instance = AppDatabase(_openConnection(file));
    _currentUserId = userId;
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
