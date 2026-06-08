import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:drift/drift.dart';

class EmojiPackageEmojiService extends BaseService {
  const EmojiPackageEmojiService();

  Future<void> batchCreate(
    List<EmojiPackageEmojiTableCompanion> entries,
  ) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojiPackageEmojiTable,
          entry,
          onConflict: DoUpdate(
            (old) => entry,
            target: [db.emojiPackageEmojiTable.relationId],
          ),
        );
      }
    });
  }

  Future<List<EmojiPackageEmojiTableData>> getByPackageId(
    String packageId,
  ) async {
    final query = db.select(db.emojiPackageEmojiTable)
      ..where((t) => t.packageId.equals(packageId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return await query.get();
  }

  Future<List<Emoji>> getEmojisByPackageId(String packageId) async {
    final query = db.select(db.emojis).join([
      innerJoin(
        db.emojiPackageEmojiTable,
        db.emojiPackageEmojiTable.emojiId.equalsExp(db.emojis.emojiId),
      ),
    ]);
    query.where(db.emojiPackageEmojiTable.packageId.equals(packageId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.emojis)).toList();
  }
}
