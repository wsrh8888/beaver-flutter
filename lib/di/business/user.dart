import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/types/business/user.dart';

/// 用户业务层依赖配置
void configureUserBusinessDependencies(GetIt getIt) {
  // 业务门面层 (确保只有一个实例)
  getIt.registerLazySingleton<UserBusiness>(() => UserBusiness());
  
  // 业务接口注册 (重用同一个实例)
  getIt.registerLazySingleton<UserRepositoryInterface>(() => getIt<UserBusiness>());
}
