import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/auth/pages/login_page.dart';
import 'package:beaver/features/auth/pages/register_page.dart';
import 'package:beaver/features/home/pages/main_screen.dart';

// 路由路径常量
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login, 
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
    ),
  ],
);
