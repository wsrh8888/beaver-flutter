import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/moment/moment.dart';

void configureMomentBusinessDependencies(GetIt getIt) {
  getIt.registerLazySingleton<MomentBusiness>(() => MomentBusiness());
}
