import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

class EmojiPackageCollectService {
  final AppDatabase _db;

  EmojiPackageCollectService(this._db);

  Future<void> batchCreate(
    List<EmojiPackageCollectTableCompanion> entries,
  ) async {
    await _db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          _db.emojiPackageCollectTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [_db.emojiPackageCollectTable.packageCollectId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiPackageCollectTableData>> getCollectsByIds(
    List<String> ids,
  ) async {
    final query = _db.select(_db.emojiPackageCollectTable)
      ..where((t) => t.packageCollectId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageCollectId: item};
  }
}
