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
