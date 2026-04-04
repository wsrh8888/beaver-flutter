import 'package:go_router/go_router.dart';
import 'package:beaver/features/common/webview/webview.dart';
import 'package:beaver/features/common/scan/scan.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> commonRoutes() {
  return [
    GoRoute(
      path: AppRoutes.webview,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final title = state.uri.queryParameters['title'];
        return WebViewPage(url: url, title: title);
      },
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScanPage(),
    ),
  ];
}
