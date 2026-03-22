import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

abstract class EmojiBusinessInterface {
  Future<EmojiModel?> getEmojiById(String emojiId);
}

class EmojiBusiness implements EmojiBusinessInterface {
  final _emojiService = getIt<EmojiService>();

  @override
  Future<EmojiModel?> getEmojiById(String emojiId) async {
    final emoji = await _emojiService.getEmojiById(emojiId);
    if (emoji == null) return null;
    return EmojiModel(
      emojiId: emoji.emojiId,
      name: emoji.title,
      fileKey: emoji.fileKey,
      version: emoji.version,
    );
  }
}
