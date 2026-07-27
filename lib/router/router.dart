import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/home/main/main.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/router/guards/auth_guard.dart';
import 'package:beaver/router/modules/auth.dart';
import 'package:beaver/router/modules/chat.dart';
import 'package:beaver/router/modules/contact.dart';
import 'package:beaver/router/modules/moment.dart';
import 'package:beaver/router/modules/group.dart';
import 'package:beaver/router/modules/calls.dart';
import 'package:beaver/router/modules/discover.dart';
import 'package:beaver/router/modules/setting.dart';
import 'package:beaver/router/modules/guide.dart';
import 'package:beaver/router/modules/user.dart';
import 'package:beaver/router/modules/emoji.dart';
import 'package:beaver/router/modules/common.dart';
import 'package:beaver/router/modules/circle.dart';
import 'package:beaver/router/modules/workbench.dart';
import 'package:beaver/router/modules/oauth.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    return AuthGuard.redirect(context, state);
  },
  routes: [
    // 基础路由
    GoRoute(
      path: AppRoutes.root,
      builder: (context, state) => const MainScreen(),
    ),
    // 认证模块路由
    ...authRoutes(),
    // 聊天模块路由
    ...chatRoutes(),
    // 联系人模块路由
    ...contactRoutes(),
    // 动态模块路由
    ...momentRoutes(),
    // 群组模块路由
    ...groupRoutes(),
    // 通话模块路由
    ...callsRoutes(),
    // 发现模块路由
    ...discoverRoutes(),
    // 设置模块路由
    ...settingRoutes(),
    // 引导模块路由
    ...guideRoutes(),
    // 用户模块路由
    ...userRoutes(),
    // 表情模块路由
    ...emojiRoutes(),
    // 通用模块路由
    ...commonRoutes(),
    // 圈子模块路由
    ...circleRoutes(),
    // 工作台模块路由
    ...workbenchRoutes(),
    // OAuth 扫码授权
    ...oauthRoutes(),
    // 深度链接支持
    GoRoute(
      path: '/share/:type/:id',
      redirect: (context, state) {
        final type = state.pathParameters['type'];
        final id = state.pathParameters['id'];
        if (type == 'circle' && id != null && id.isNotEmpty) {
          return '${AppRoutes.circleJoin}?circleId=${Uri.encodeComponent(id)}';
        }
        return AppRoutes.root;
      },
    ),
  ],
);
