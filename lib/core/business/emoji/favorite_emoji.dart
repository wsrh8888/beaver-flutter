import 'package:beaver/core/database/services/emoji/collect.dart';
import 'package:beaver/core/database/services/emoji/emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

abstract class FavoriteEmojiBusinessInterface {
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500});
}

class FavoriteEmojiBusiness implements FavoriteEmojiBusinessInterface {
  final _emojiCollectService = getIt<EmojiCollectService>();
  final _emojiService = getIt<EmojiService>();
  
  @override
  Future<List<FavoriteEmojiModel>> getUserFavoriteEmojis({int page = 1, int size = 500}) async {
    final collects = await _emojiCollectService.getUserCollects(page: page, size: size);
    if (collects.isEmpty) return [];
    
    final emojiIds = collects.map((c) => c.emojiId).toList();
    final emojis = await _emojiService.getEmojisByIds(emojiIds);
    
    return collects.map((collect) {
      final emoji = emojis[collect.emojiId];
      return FavoriteEmojiModel(
        emojiId: collect.emojiId,
        fileKey: emoji?.fileKey ?? '',
        title: emoji?.title ?? '',
        packageId: collect.packageId,
      );
    }).toList();
  }
}
