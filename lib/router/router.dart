/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('router');

/// 路由导航追踪：记录每一次页面跳转，便于排查"卡在哪个页面/跳转异常"
class RouteLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info({
      'text': '页面入栈',
      'data': {
        'route': route.settings.name ?? route.settings.arguments?.toString(),
        'path': route.settings.name,
        'from': previousRoute?.settings.name,
      },
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info({
      'text': '页面出栈',
      'data': {
        'route': route.settings.name,
        'to': previousRoute?.settings.name,
      },
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logger.info({
      'text': '页面替换',
      'data': {
        'newRoute': newRoute?.settings.name,
        'oldRoute': oldRoute?.settings.name,
      },
    });
  }
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final RouteLogger routeLogger = RouteLogger();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  observers: [routeLogger],
  redirect: (context, state) {
    _logger.info({
      'text': '路由守卫拦截',
      'data': {'location': state.uri.toString()},
    });
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
        if (type == 'group' && id != null && id.isNotEmpty) {
          return '${AppRoutes.groupJoin}?groupId=${Uri.encodeComponent(id)}';
        }
        return AppRoutes.root;
      },
    ),
  ],
);
