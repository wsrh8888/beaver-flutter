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
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/shared/utils/qrcode/index.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final token = StorageUtil.getString('token');
    final userId = StorageUtil.getString('userId');
    final isLoggedIn =
        token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;
    final currentPath = state.uri.path;

    // 已登录用户访问登录/注册页，跳转到首页
    if (isLoggedIn &&
        (currentPath == AppRoutes.login || currentPath == AppRoutes.register)) {
      return AppRoutes.root;
    }

    // 未登录访问 OAuth 确认页，暂存 sceneId 后跳转登录
    if (!isLoggedIn && currentPath == AppRoutes.oauthScanConfirm) {
      final sceneId = state.uri.queryParameters['sceneId'];
      if (sceneId != null && sceneId.isNotEmpty) {
        StorageUtil.setString(pendingOAuthSceneKey, sceneId);
      }
      return AppRoutes.login;
    }

    // 未登录访问圈子分享深链，暂存 circleId
    if (!isLoggedIn) {
      String? circleId;
      if (currentPath == AppRoutes.circleJoin) {
        circleId = state.uri.queryParameters['circleId'];
      } else if (currentPath.startsWith('/share/circle/')) {
        circleId = state.pathParameters['id'] ??
            parseCircleIdFromShare(state.uri.toString());
      }
      if (circleId != null && circleId.isNotEmpty) {
        savePendingCircleShare(circleId);
        return AppRoutes.login;
      }
    }

    // 未登录用户访问需要认证的页面，跳转到登录页
    if (!isLoggedIn &&
        currentPath != AppRoutes.login &&
        currentPath != AppRoutes.register &&
        currentPath != AppRoutes.forgotPassword) {
      return AppRoutes.login;
    }

    return null;
  }
}
