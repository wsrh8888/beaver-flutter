import 'package:beaver/core/database/services/emoji/package.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';

abstract class EmojiPackageBusinessInterface {
  Future<List<EmojiPackageModel>> getEmojiPackages({int page = 1, int size = 200});
}

class EmojiPackageBusiness implements EmojiPackageBusinessInterface {
  final _emojiPackageService = getIt<EmojiPackageService>();

  @override
  Future<List<EmojiPackageModel>> getEmojiPackages({int page = 1, int size = 200}) async {
    final packages = await _emojiPackageService.getPackages(page: page, size: size);
    return packages.map((row) => EmojiPackageModel(
      packageId: row.packageId,
      title: row.title,
      coverFile: row.coverFile ?? '',
    )).toList();
  }
}
