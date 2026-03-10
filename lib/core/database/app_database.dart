import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

// 用户信息表 (对标 UserCollection)
class Users extends Table {
  TextColumn get userId => text()();
  TextColumn get username => text().nullable()();
  TextColumn get avatar => text().nullable()();
  IntColumn get lastSyncAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

// 消息记录表 (对标 ChatCollection)
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text().withLength(min: 1, max: 64)();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get content => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get localStatus => integer().withDefault(const Constant(0))();
  IntColumn get seq => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (messageId)',
  ];
}

@DriftDatabase(tables: [Users, Chats])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

/// 数据库工厂 (支持多账号隔离)
class DatabaseManager {
  static AppDatabase? _instance;
  static String? _currentUserId;

  static AppDatabase get instance {
    if (_instance == null) {
      throw Exception('Database not initialized. Call init(userId) first.');
    }
    return _instance!;
  }

  static Future<void> init(String userId) async {
    if (_instance != null && _currentUserId == userId) return;
    
    // 如果已经有一个实例且是不同账号，先关闭旧的
    await close();

    final dbFolder = await getApplicationDocumentsDirectory();
    final userFolder = Directory(p.join(dbFolder.path, 'users', userId));
    if (!await userFolder.exists()) {
      await userFolder.create(recursive: true);
    }
    
    final file = File(p.join(userFolder.path, 'db.sqlite'));
    
    _instance = AppDatabase(_openConnection(file));
    _currentUserId = userId;
    
    print('[Drift] Database initialized for user: $userId');
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
