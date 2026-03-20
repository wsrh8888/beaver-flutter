import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/types/business/group.dart';

/// 群组业务层依赖配置
void configureGroupBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  
  // 业务接口注册
  getIt.registerLazySingleton<GroupRepositoryInterface>(() => GroupBusiness());
}
