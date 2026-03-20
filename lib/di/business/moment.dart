import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/moment/moment.dart';
import 'package:beaver/types/business/moment.dart';

/// 动态业务层依赖配置
void configureMomentBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<MomentBusiness>(() => MomentBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<MomentRepositoryInterface>(() => MomentBusiness());
}
