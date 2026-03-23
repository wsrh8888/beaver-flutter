import 'package:go_router/go_router.dart';
import 'package:beaver/features/guide/main/main.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> guideRoutes() {
  return [
    GoRoute(
      path: AppRoutes.guideMain,
      builder: (context, state) => const GuideMainPage(),
    ),
  ];
}
