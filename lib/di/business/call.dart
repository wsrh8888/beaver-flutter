import 'package:get_it/get_it.dart';
import 'package:beaver/core/business/call/call.dart';

void configureCallBusinessDependencies(GetIt getIt) {
  getIt.registerLazySingleton<CallBusiness>(() => CallBusiness());
}
