import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

class EmojiCollectService {
  final AppDatabase _db;

  EmojiCollectService(this._db);

  Future<void> batchCreate(List<EmojiCollectTableCompanion> entries) async {
    await _db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          _db.emojiCollectTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [_db.emojiCollectTable.emojiCollectId],
          ),
        );
      }
    });
  }

  Future<Map<String, EmojiCollectTableData>> getCollectsByIds(
    List<String> ids,
  ) async {
    final query = _db.select(_db.emojiCollectTable)
      ..where((t) => t.emojiCollectId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.emojiCollectId: item};
  }

  Future<List<EmojiCollectTableData>> getAll() async {
    return await _db.select(_db.emojiCollectTable).get();
  }

  Future<List<EmojiCollectTableData>> getUserCollects({
    int page = 1,
    int size = 500,
  }) async {
    final query = _db.select(_db.emojiCollectTable)
      ..where((t) => t.isDeleted.equals(0))
      ..limit(size, offset: (page - 1) * size);
    return await query.get();
  }
}
