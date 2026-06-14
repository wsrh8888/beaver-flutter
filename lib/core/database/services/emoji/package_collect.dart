import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:drift/drift.dart';

class EmojiPackageCollectService extends BaseService {
  const EmojiPackageCollectService();

  Future<void> batchCreate(
    List<EmojiPackageCollectTableCompanion> entries,
  ) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiPackageCollectTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiPackageCollectTable.packageCollectId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiPackageCollectTableData>> getCollectsByIds(
    List<String> ids,
  ) async {
    final query = db.select(db.emojiPackageCollectTable)
      ..where((t) => t.packageCollectId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageCollectId: item};
  }
}
