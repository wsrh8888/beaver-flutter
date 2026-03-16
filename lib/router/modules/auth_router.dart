import 'package:go_router/go_router.dart';
import 'package:beaver/features/auth/login/login.dart';
import 'package:beaver/features/auth/register/register.dart';


class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}

List<GoRoute> authRoutes = [
  GoRoute(
    path: AuthRoutes.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AuthRoutes.register,
    builder: (context, state) => const RegisterPage(),
  ),
  // 可以在这里添加更多认证相关路由
];

