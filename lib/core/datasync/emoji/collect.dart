import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiCollectSync {
  Future<void> sync(List<IEmojiCollectVersionItem> versions) async {
    final emojiCollectService = getIt<EmojiCollectService>();
    final ids = versions.map((v) => v.emojiCollectId).toList();
    
    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(i, i + batchSize > ids.length ? ids.length : i + batchSize);
      final detailRes = await getEmojiCollectsByIdsApi({'ids': batchIds});
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.collects.map((item) {
          return EmojiCollectTableCompanion(
            emojiCollectId: Value(item.emojiCollectId),
            userId: Value(item.userId),
            emojiId: Value(item.emojiId),
            packageId: Value(item.packageId),
            version: Value(item.version),
            isDeleted: Value(item.status == 0 ? 1 : 0),
          );
        }).toList();
        await emojiCollectService.batchCreate(companions);
      }
    }
  }
}
