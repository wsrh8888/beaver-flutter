import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/types/business/call.dart';

/// 通话业务层依赖配置
void configureCallBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<CallBusiness>(() => CallBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<CallRepositoryInterface>(() => CallBusiness());
}
