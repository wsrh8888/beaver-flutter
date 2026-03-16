import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/auth/login/login.dart';
import 'package:beaver/features/auth/register/register.dart';
import 'package:beaver/router/modules/auth_router.dart';
import 'package:beaver/features/home/main/main.dart';
import 'package:beaver/features/moment/post/post.dart' as beaver_moment_post;
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
    final currentPath = state.uri.path;
    // 如果已登录且在登录页，跳转到首页
    if (isLoggedInValue && currentPath == AppRoutes.login) {
      return AppRoutes.home;
    }
    
    // 如果未登录且不在登录/注册页，跳转到登录页
    if (!isLoggedInValue && currentPath != AppRoutes.login && currentPath != AuthRoutes.register) {
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
      path: AuthRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/moment/post',
      builder: (context, state) {
        // You'll need to import the post moment page at the top
        // Since it's dynamically added here, I am using dynamic load or direct import
        // Let's import it properly
        return const beaver_moment_post.PostMomentPage();
      },
    ),
  ],
);

