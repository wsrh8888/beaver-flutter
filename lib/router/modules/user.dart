import 'package:go_router/go_router.dart';
import 'package:beaver/features/user/profile/profile.dart';
import 'package:beaver/features/user/qrcode/qrcode.dart';
import 'package:beaver/features/user/config/config.dart';

List<RouteBase> userRoutes() {
  return [
    GoRoute(
      path: '/user/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/user/qrcode',
      builder: (context, state) => const QrcodePage(),
    ),
    GoRoute(
      path: '/user/config',
      builder: (context, state) => const UserConfigPage(),
    ),
  ];
}
