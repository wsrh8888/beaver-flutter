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
import 'package:beaver/common/config/env.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/shared/ui/toast/index.dart';

const pendingOAuthSceneKey = 'pending_oauth_scene';

bool isOAuthQr(String code) {
  final uri = Uri.tryParse(code);
  if (uri == null) {
    return false;
  }

  if (uri.scheme == 'beaver' && uri.host == 'oauth') {
    return uri.path == '/scan' && uri.queryParameters['sceneId'] != null;
  }

  if (uri.scheme == 'http' || uri.scheme == 'https') {
    final base = Uri.parse(oauthBaseUrl);
    if (uri.scheme != base.scheme || uri.host != base.host || uri.port != base.port) {
      return false;
    }
    return uri.path == '/scan' && uri.queryParameters['sceneId'] != null;
  }

  return false;
}

class OAuthQrHandler {
  void handle(BuildContext context, String code) {
    final uri = Uri.parse(code);
    final sceneId = uri.queryParameters['sceneId']!;

    final token = StorageUtil.getString('token');
    final userId = StorageUtil.getString('userId');
    final isLoggedIn =
        token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;

    if (!isLoggedIn) {
      StorageUtil.setString(pendingOAuthSceneKey, sceneId);
      BeaverToast.show(context, '请先登录后再确认授权');
      context.replace(AppRoutes.login);
      return;
    }

    context.replace(
      '${AppRoutes.oauthScanConfirm}?sceneId=${Uri.encodeComponent(sceneId)}',
    );
  }
}

Future<String?> consumePendingOAuthScene() async {
  final sceneId = StorageUtil.getString(pendingOAuthSceneKey);
  if (sceneId == null || sceneId.isEmpty) {
    return null;
  }
  await StorageUtil.remove(pendingOAuthSceneKey);
  return sceneId;
}

final oauthQrHandler = OAuthQrHandler();
