import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiPackageCollectSync {
  Future<void> sync(List<IEmojiPackageCollectVersionItem> versions) async {
    final service = getIt<EmojiPackageCollectService>();
    final ids = versions.map((v) => v.packageCollectId).toList();

    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(
        i,
        i + batchSize > ids.length ? ids.length : i + batchSize,
      );
      final detailRes = await getEmojiPackageCollectsByIdsApi({
        'ids': batchIds,
      });
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.collects.map((item) {
          return EmojiPackageCollectTableCompanion(
            packageCollectId: Value(item.packageId),
            userId: Value(item.userId),
            packageId: Value(item.packageId),
            version: Value(item.version),
            isDeleted: Value(0),
          );
        }).toList();
        await service.batchCreate(companions);
      }
    }
  }
}
