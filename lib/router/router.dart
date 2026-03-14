import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/auth/pages/login_page.dart';
import 'package:beaver/features/auth/pages/register_page.dart';
import 'package:beaver/features/home/pages/main_screen.dart';
import 'package:beaver/shared/utils/storage_util.dart';

// 路由路径常量
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// 检查是否已登录
bool isLoggedIn() {
  final token = StorageUtil.getString('token');
  final userId = StorageUtil.getString('userId');
  return token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    final isLoggedInValue = isLoggedIn();
    final currentPath = state.location;
    
    // 如果已登录且在登录页，跳转到首页
    if (isLoggedInValue && currentPath == AppRoutes.login) {
      return AppRoutes.home;
    }
    
    // 如果未登录且不在登录/注册页，跳转到登录页
    if (!isLoggedInValue && currentPath != AppRoutes.login && currentPath != AppRoutes.register) {
      return AppRoutes.login;
    }
    
    return null; // 不重定向
  },
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
