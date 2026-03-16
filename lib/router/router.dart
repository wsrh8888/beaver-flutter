import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/home/main/main.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/router/modules/auth_router.dart';
import 'package:beaver/router/modules/chat_router.dart';
import 'package:beaver/router/modules/contact_router.dart';



// 路由路径常量
class AppRoutes {
  static const String home = '/';
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
  initialLocation: AuthRoutes.login,
  redirect: (context, state) {
    final isLoggedInValue = isLoggedIn();
    final currentPath = state.uri.path;
    // 如果已登录且在登录页，跳转到首页
    if (isLoggedInValue && currentPath == AuthRoutes.login) {
      return AppRoutes.home;
    }
    
    // 如果未登录且不在登录/注册页，跳转到登录页
    if (!isLoggedInValue && currentPath != AuthRoutes.login && currentPath != AuthRoutes.register) {
      return AuthRoutes.login;
    }
    
    return null; // 不重定向
  },
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
    ),
    ...authRoutes,
    ...chatRoutes,
    ...contactRoutes,
  ],
);
