import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/types/business/group.dart';
import 'package:get_it/get_it.dart';

/// 群组业务层依赖配置
void configureGroupBusinessDependencies(GetIt getIt) {
  // 业务门面层
  getIt.registerLazySingleton<GroupBusiness>(() => GroupBusiness());
  getIt.registerLazySingleton<GroupJoinRequestBusiness>(
    () => GroupJoinRequestBusiness(),
  );
  getIt.registerLazySingleton<GroupMemberBusiness>(() => GroupMemberBusiness());

  // 业务接口注册
  getIt.registerLazySingleton<GroupRepositoryInterface>(
    () => getIt<GroupBusiness>(),
  );
}
