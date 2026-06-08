import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';
import 'package:drift/drift.dart';

class EmojiService extends BaseService {
  const EmojiService();

  Future<void> batchCreate(List<EmojisCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          db.emojis,
          entry,
          onConflict: DoUpdate((old) => entry, target: [db.emojis.emojiId]),
        );
      }
    });
  }

  Future<Map<String, Emoji>> getEmojisByIds(List<String> ids) async {
    final query = db.select(db.emojis)..where((t) => t.emojiId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.emojiId: item};
  }

  Future<Emoji?> getEmojiById(String id) async {
    return await (db.select(
      db.emojis,
    )..where((t) => t.emojiId.equals(id))).getSingleOrNull();
  }
}
