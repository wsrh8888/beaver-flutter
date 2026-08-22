import 'package:go_router/go_router.dart';
import 'package:beaver/features/workbench/home/home.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> workbenchRoutes() {
  return [
    GoRoute(
      path: AppRoutes.workbenchHome,
      builder: (context, state) => const WorkbenchHomePage(showBack: true),
    ),
  ];
}
