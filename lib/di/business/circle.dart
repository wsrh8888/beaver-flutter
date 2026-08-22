import 'package:beaver/core/business/circle/circle.dart';
import 'package:get_it/get_it.dart';

void configureCircleBusinessDependencies(GetIt getIt) {
  getIt.registerLazySingleton<CircleBusiness>(() => CircleBusiness());
}
