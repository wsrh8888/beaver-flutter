import 'package:beaver/core/business/emoji/favorite_emoji.dart';
import 'package:beaver/core/business/emoji/package.dart';
import 'package:beaver/core/business/emoji/package_emoji.dart';
import 'package:beaver/core/business/emoji/emoji.dart';
import 'package:beaver/core/database/database.dart';
import 'package:get_it/get_it.dart';

void configureEmojiBusinessDependencies(GetIt getIt) {
  getIt.registerLazySingleton<EmojiBusinessInterface>(
    () => EmojiBusiness(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<FavoriteEmojiBusinessInterface>(
    () => FavoriteEmojiBusiness(),
  );
  getIt.registerLazySingleton<EmojiPackageBusinessInterface>(
    () => EmojiPackageBusiness(),
  );
  getIt.registerLazySingleton<PackageEmojiBusinessInterface>(
    () => PackageEmojiBusiness(),
  );
}
