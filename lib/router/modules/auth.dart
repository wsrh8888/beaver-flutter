import 'package:go_router/go_router.dart';
import 'package:beaver/features/auth/login/login.dart';
import 'package:beaver/features/auth/register/register.dart';
import 'package:beaver/features/auth/forget/forget.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> authRoutes() {
  return [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgetPasswordPage(),
    ),
  ];
}
