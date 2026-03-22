import 'package:beaver/core/database/db.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:drift/drift.dart';

abstract class PackageEmojiBusinessInterface {
  Future<List<EmojiModel>> getPackageEmojis(String packageId);
}

class PackageEmojiBusiness implements PackageEmojiBusinessInterface {
  AppDatabase get _db => DatabaseManager.instance;

  @override
  Future<List<EmojiModel>> getPackageEmojis(String packageId) async {
    final query = _db.select(_db.emojis).join([
      innerJoin(
        _db.emojiPackageEmojiTable,
        _db.emojiPackageEmojiTable.emojiId.equalsExp(_db.emojis.emojiId),
      ),
    ]);
    query.where(_db.emojiPackageEmojiTable.packageId.equals(packageId));
    
    final rows = await query.get();
    return rows.map((row) {
      final emoji = row.readTable(_db.emojis);
      return EmojiModel(
        emojiId: emoji.emojiId,
        name: emoji.title,
        fileKey: emoji.fileKey,
        version: emoji.version,
        packageId: packageId,
      );
    }).toList();
  }
}
