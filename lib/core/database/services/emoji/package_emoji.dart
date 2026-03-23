import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

class EmojiPackageEmojiService {
  final AppDatabase _db;

  EmojiPackageEmojiService(this._db);

  Future<void> batchCreate(List<EmojiPackageEmojiTableCompanion> entries) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.emojiPackageEmojiTable, entries);
    });
  }

  Future<List<EmojiPackageEmojiTableData>> getByPackageId(String packageId) async {
    final query = _db.select(_db.emojiPackageEmojiTable)
      ..where((t) => t.packageId.equals(packageId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return await query.get();
  }

  Future<List<Emoji>> getEmojisByPackageId(String packageId) async {
    final query = _db.select(_db.emojis).join([
      innerJoin(
        _db.emojiPackageEmojiTable,
        _db.emojiPackageEmojiTable.emojiId.equalsExp(_db.emojis.emojiId),
      ),
    ]);
    query.where(_db.emojiPackageEmojiTable.packageId.equals(packageId));
    
    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.emojis)).toList();
  }
}
