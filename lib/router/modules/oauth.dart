import 'package:go_router/go_router.dart';
import 'package:beaver/features/oauth/scan/scan_confirm.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> oauthRoutes() {
  return [
    GoRoute(
      path: AppRoutes.oauthScanConfirm,
      builder: (context, state) {
        final sceneId = state.uri.queryParameters['sceneId'] ?? '';
        return OAuthScanConfirmPage(sceneId: sceneId);
      },
    ),
  ];
}
