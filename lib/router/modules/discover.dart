import 'package:go_router/go_router.dart';
import 'package:beaver/features/discover/main/main.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> discoverRoutes() {
  return [
    GoRoute(
      path: AppRoutes.discoverMain,
      builder: (context, state) => const DiscoverMainPage(),
    ),
  ];
}
