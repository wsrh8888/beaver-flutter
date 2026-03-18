import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class DatasyncService extends BaseService {
  DatasyncService(super.db);

  Future<DatasyncData?> get(String module) async {
    return (db.select(db.datasync)..where((t) => t.module.equals(module))).getSingleOrNull();
  }

  Future<void> upsert(String module, int? version, int updatedAt) async {
    final existing = await get(module);
    if (existing != null) {
      await (db.update(db.datasync)..where((t) => t.module.equals(module))).write(
        DatasyncCompanion(
          version: Value(version),
          updatedAt: Value(updatedAt),
        ),
      );
    } else {
      await db.into(db.datasync).insert(
        DatasyncCompanion(
          module: Value(module),
          version: Value(version),
          updatedAt: Value(updatedAt),
        ),
      );
    }
  }
}
