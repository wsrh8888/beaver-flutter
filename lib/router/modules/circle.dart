import 'package:go_router/go_router.dart';
import 'package:beaver/features/circle/list/list.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> circleRoutes() {
  return [
    GoRoute(
      path: AppRoutes.circleList,
      builder: (context, state) => const CircleListPage(),
    ),
  ];
}
