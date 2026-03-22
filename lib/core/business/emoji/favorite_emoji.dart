import 'package:beaver/core/database/db.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:drift/drift.dart';

abstract class FavoriteEmojiBusinessInterface {
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500});
}

class FavoriteEmojiBusiness implements FavoriteEmojiBusinessInterface {
  AppDatabase get _db => DatabaseManager.instance;
  
  @override
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500}) async {
    final query = _db.select(_db.emojiCollectTable).join([
      leftOuterJoin(
        _db.emojis,
        _db.emojis.emojiId.equalsExp(_db.emojiCollectTable.emojiId),
      ),
    ]);
    query.where(_db.emojiCollectTable.isDeleted.equals(0));
    query.limit(size, offset: (page - 1) * size);
    
    final rows = await query.get();
    return rows.map((row) {
      final collect = row.readTable(_db.emojiCollectTable);
      final emoji = row.readTableOrNull(_db.emojis);
      return FavoriteEmojiModel(
        emojiId: collect.emojiId,
        fileKey: emoji?.fileKey ?? '',
        title: emoji?.title ?? '',
        packageId: collect.packageId,
      );
    }).toList();
  }
}
