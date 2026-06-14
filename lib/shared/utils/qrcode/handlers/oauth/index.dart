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
