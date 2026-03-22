import 'package:beaver/core/database/db.dart';
import 'package:beaver/types/business/emoji.dart';

abstract class EmojiPackageBusinessInterface {
  Future<List<EmojiPackageModel>> getEmojiPackages({int page = 1, int size = 200});
}

class EmojiPackageBusiness implements EmojiPackageBusinessInterface {
  AppDatabase get _db => DatabaseManager.instance;

  @override
  Future<List<EmojiPackageModel>> getEmojiPackages({int page = 1, int size = 200}) async {
    final query = _db.select(_db.emojiPackageTable)
      ..limit(size, offset: (page - 1) * size);
    final rows = await query.get();
    return rows.map((row) => EmojiPackageModel(
      packageId: row.packageId,
      title: row.title,
      coverFile: row.coverFile ?? '',
    )).toList();
  }
}
