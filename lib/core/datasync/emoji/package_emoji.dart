import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiPackageEmojiSync {
  Future<void> sync(List<IEmojiPackageContentVersionItem> versions) async {
    final service = getIt<EmojiPackageEmojiService>();
    final ids = versions.map((v) => v.packageId).toList();

    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(
        i,
        i + batchSize > ids.length ? ids.length : i + batchSize,
      );
      final detailRes = await getEmojiPackageContentsByPackageIdsApi({
        'packageIds': batchIds,
      });
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.contents.map((item) {
          return EmojiPackageEmojiTableCompanion(
            relationId: Value(item.relationId),
            packageId: Value(item.packageId),
            emojiId: Value(item.emojiId),
            sortOrder: Value(item.sortOrder),
            version: Value(item.version),
            createdAt: Value(item.createdAt),
            updatedAt: Value(item.updatedAt),
          );
        }).toList();
        await service.batchCreate(companions);
      }
    }
  }
}
