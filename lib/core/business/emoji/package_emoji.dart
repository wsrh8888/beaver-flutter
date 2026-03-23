import 'package:beaver/core/database/services/emoji/package_emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

abstract class PackageEmojiBusinessInterface {
  Future<List<EmojiModel>> getPackageEmojis(String packageId);
}

class PackageEmojiBusiness implements PackageEmojiBusinessInterface {
  final _emojiPackageEmojiService = getIt<EmojiPackageEmojiService>();

  @override
  Future<List<EmojiModel>> getPackageEmojis(String packageId) async {
    final emojis = await _emojiPackageEmojiService.getEmojisByPackageId(packageId);
    return emojis.map((emoji) => EmojiModel(
      emojiId: emoji.emojiId,
      name: emoji.title,
      fileKey: emoji.fileKey,
      version: emoji.version,
      packageId: packageId,
    )).toList();
  }
}
