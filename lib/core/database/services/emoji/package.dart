import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:drift/drift.dart';

class EmojiPackageService extends BaseService {
  const EmojiPackageService();

  Future<void> batchCreate(List<EmojiPackageTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiPackageTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiPackageTable.packageId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiPackageTableData>> getPackagesByIds(
    List<String> ids,
  ) async {
    final query = db.select(db.emojiPackageTable)
      ..where((t) => t.packageId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageId: item};
  }

  Future<List<EmojiPackageTableData>> getAll() async {
    return await db.select(db.emojiPackageTable).get();
  }

  Future<List<EmojiPackageTableData>> getPackages({
    int page = 1,
    int size = 200,
  }) async {
    final query = db.select(db.emojiPackageTable)
      ..limit(size, offset: (page - 1) * size);
    return await query.get();
  }
}
