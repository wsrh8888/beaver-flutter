import 'package:drift/drift.dart';

/// 全局同步游标表 (与 PC tables/datasync/datasync.ts 一致)
class Datasync extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get module => text().named('module')();
  IntColumn get version => integer().named('version').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  List<String> get customConstraints => ['UNIQUE (module)'];
}
