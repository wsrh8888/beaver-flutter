import 'package:go_router/go_router.dart';
import 'package:beaver/features/calls/calls_page/calls_page.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> callsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.callsPage,
      builder: (context, state) => const CallsPage(),
    ),
  ];
}
