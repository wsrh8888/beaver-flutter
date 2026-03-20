import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/types/business/user.dart';

/// 用户业务层依赖配置
void configureUserBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<UserBusiness>(() => UserBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<UserRepositoryInterface>(() => UserBusiness());
}
