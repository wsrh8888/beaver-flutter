import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

class EmojiPackageService {
  final AppDatabase _db;

  EmojiPackageService(this._db);

  Future<void> batchCreate(List<EmojiPackageTableCompanion> entries) async {
    await _db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          _db.emojiPackageTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [_db.emojiPackageTable.packageId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiPackageTableData>> getPackagesByIds(
    List<String> ids,
  ) async {
    final query = _db.select(_db.emojiPackageTable)
      ..where((t) => t.packageId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.packageId: item};
  }

  Future<List<EmojiPackageTableData>> getAll() async {
    return await _db.select(_db.emojiPackageTable).get();
  }

  Future<List<EmojiPackageTableData>> getPackages({
    int page = 1,
    int size = 200,
  }) async {
    final query = _db.select(_db.emojiPackageTable)
      ..limit(size, offset: (page - 1) * size);
    return await query.get();
  }
}
