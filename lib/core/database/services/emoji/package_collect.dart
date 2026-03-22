import 'package:beaver/core/database/db.dart';

class EmojiPackageCollectService {
  final AppDatabase _db;

  EmojiPackageCollectService(this._db);

  Future<void> batchCreate(List<EmojiPackageCollectTableCompanion> entries) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.emojiPackageCollectTable, entries);
    });
  }

  Future<Map<String, EmojiPackageCollectTableData>> getCollectsByIds(List<String> ids) async {
    final query = _db.select(_db.emojiPackageCollectTable)
      ..where((t) => t.packageCollectId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageCollectId: item};
  }
}
