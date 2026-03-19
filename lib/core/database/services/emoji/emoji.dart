import 'package:drift/drift.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/base.dart';

class EmojiService extends BaseService {
  EmojiService(super.db);

  /// 创建表情
  Future<void> create(EmojisCompanion emoji) async {
    await db.into(db.emojis).insert(emoji);
  }

  /// 批量创建表情（upsert操作）
  Future<void> batchCreate(List<EmojisCompanion> emojiList) async {
    if (emojiList.isEmpty) {
      return;
    }

    await db.batch((batch) {
      for (final emojiData in emojiList) {
        batch.insert(
          db.emojis,
          emojiData,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// 根据ID列表获取表情
  Future<Map<String, Emoji>> getEmojisByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return {};
    }

    final emojiList = await (db.select(db.emojis)..where((t) => t.emojiId.isIn(ids))).get();

    final emojiMap = <String, Emoji>{};
    for (final item in emojiList) {
      emojiMap[item.emojiId] = item;
    }

    return emojiMap;
  }

  /// 获取所有表情
  Future<List<Emoji>> getAllEmojis() async {
    return db.select(db.emojis).get();
  }

  /// 根据ID获取单个表情
  Future<Emoji?> getEmojiById(String id) async {
    return (db.select(db.emojis)..where((t) => t.emojiId.equals(id))).getSingleOrNull();
  }
}
