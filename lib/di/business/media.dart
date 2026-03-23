import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/media/media.dart';

/// 媒体业务依赖注册
void configureMediaBusinessDependencies(GetIt getIt) {
  getIt.registerLazySingleton<MediaBusiness>(() => MediaBusiness());
}
