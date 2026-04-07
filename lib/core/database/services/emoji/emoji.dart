import 'package:beaver/core/database/db.dart';
import 'package:drift/drift.dart';

class EmojiService {
  final AppDatabase _db;

  EmojiService(this._db);

  Future<void> batchCreate(List<EmojisCompanion> entries) async {
    await _db.batch((batch) {
      for (final entry in entries) {
        batch.insert(
          _db.emojis,
          entry,
          onConflict: DoUpdate((old) => entry, target: [_db.emojis.emojiId]),
        );
      }
    });
  }

  Future<Map<String, Emoji>> getEmojisByIds(List<String> ids) async {
    final query = _db.select(_db.emojis)..where((t) => t.emojiId.isIn(ids));
    final result = await query.get();
    return {for (var item in result) item.emojiId: item};
  }

  Future<Emoji?> getEmojiById(String id) async {
    return await (_db.select(
      _db.emojis,
    )..where((t) => t.emojiId.equals(id))).getSingleOrNull();
  }
}
