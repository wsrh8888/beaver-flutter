import 'package:get_it/get_it.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';

/// 认证相关依赖配置
void configureAuthDependencies(GetIt getIt) {
  // 登录仓库
  if (!getIt.isRegistered<LoginRepository>()) {
    getIt.registerLazySingleton<LoginRepository>(() => LoginRepository());
  }
}
