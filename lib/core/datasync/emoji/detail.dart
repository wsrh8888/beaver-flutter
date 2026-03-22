import 'package:beaver/api/datasync.dart';
import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:drift/drift.dart';

class EmojiDetailSync {
  Future<void> sync() async {
    final datasyncService = getIt<DatasyncService>();
    final emojiService = getIt<EmojiService>();

    final cursor = await datasyncService.get('emojis');
    final lastSyncTime = cursor?.version ?? 0;

    final response = await datasyncGetSyncEmojisApi(IGetSyncEmojisReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) return;

    final emojiVersions = response.result!.emojiVersions;
    if (emojiVersions.isEmpty) {
      await datasyncService.upsert('emojis', lastSyncTime, response.result!.serverTimestamp);
      return;
    }

    final ids = emojiVersions.map((v) => v.emojiId).toList();
    final localEmojis = await emojiService.getEmojisByIds(ids);
    
    final needUpdateIds = ids.where((id) {
      final local = localEmojis[id];
      final serverVersion = emojiVersions.firstWhere((v) => v.emojiId == id).version;
      return local == null || local.version < serverVersion;
    }).toList();

    if (needUpdateIds.isNotEmpty) {
      const batchSize = 50;
      for (var i = 0; i < needUpdateIds.length; i += batchSize) {
        final batchIds = needUpdateIds.sublist(i, i + batchSize > needUpdateIds.length ? needUpdateIds.length : i + batchSize);
        final detailRes = await getEmojisByIdsApi({'ids': batchIds});
        if (detailRes.code == 0 && detailRes.result != null) {
          final List emojisJson = detailRes.result['emojis'] as List;
          final emojis = emojisJson.map((json) {
            return EmojisCompanion(
              emojiId: Value(json['emojiId']),
              fileKey: Value(json['fileKey']),
              title: Value(json['title']),
              emojiInfo: Value(json['emojiInfo']?.toString()),
              status: Value(json['status'] ?? 1),
              version: Value(json['version'] ?? 0),
            );
          }).toList();
          await emojiService.batchCreate(emojis);
        }
      }
    }

    final maxVersion = emojiVersions.map((v) => v.version).fold(lastSyncTime, (a, b) => a > b ? a : b);
    await datasyncService.upsert('emojis', maxVersion, response.result!.serverTimestamp);
  }
}
