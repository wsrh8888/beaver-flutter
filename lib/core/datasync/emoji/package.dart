import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiPackageSync {
  Future<void> sync(List<IEmojiPackageVersionItem> versions) async {
    final emojiPackageService = getIt<EmojiPackageService>();
    final ids = versions.map((v) => v.packageId).toList();
    
    const batchSize = 50;
    for (var i = 0; i < ids.length; i += batchSize) {
      final batchIds = ids.sublist(i, i + batchSize > ids.length ? ids.length : i + batchSize);
      final detailRes = await getEmojiPackagesByIdsApi({'ids': batchIds});
      if (detailRes.code == 0 && detailRes.result != null) {
        final companions = detailRes.result!.packages.map((item) {
          return EmojiPackageTableCompanion(
            packageId: Value(item.packageId),
            title: Value(item.title),
            coverFile: Value(item.coverFile),
            userId: Value(item.userId),
            description: Value(item.description),
            type: Value(item.type),
            status: Value(item.status),
            version: Value(item.version),
          );
        }).toList();
        await emojiPackageService.batchCreate(companions);
      }
    }
  }
}
