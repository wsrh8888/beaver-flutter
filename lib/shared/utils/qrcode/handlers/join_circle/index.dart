import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/storage_util.dart';

const pendingCircleShareKey = 'pending_circle_share';

bool isJoinCircleQr(String code) {
  final value = code.trim();
  if (value.startsWith('{')) {
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      return data['action'] == 'joinCircle';
    } catch (_) {
      return false;
    }
  }
  return parseCircleIdFromShare(value) != null;
}

String? parseCircleIdFromShare(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null) {
    if (uri.scheme == 'beaver' &&
        uri.host == 'share' &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'circle') {
      return uri.pathSegments[1];
    }
    if (uri.pathSegments.length >= 2) {
      final shareIndex = uri.pathSegments.indexOf('share');
      if (shareIndex >= 0 &&
          shareIndex + 2 < uri.pathSegments.length &&
          uri.pathSegments[shareIndex + 1] == 'circle') {
        return uri.pathSegments[shareIndex + 2];
      }
    }
  }

  final match = RegExp(r'/share/circle/([^/?#]+)').firstMatch(value);
  return match?.group(1);
}

String buildCircleShareLink(String circleId) {
  return 'beaver://share/circle/$circleId';
}

String buildCircleInviteQrValue(String circleId) {
  return jsonEncode({
    'action': 'joinCircle',
    'appName': 'beaver',
    'version': AppConfig.version,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'expireAt': 0,
    'payload': {'circleId': circleId},
  });
}

Future<void> savePendingCircleShare(String circleId) async {
  await StorageUtil.setString(pendingCircleShareKey, circleId);
}

Future<String?> consumePendingCircleShare() async {
  final circleId = StorageUtil.getString(pendingCircleShareKey);
  if (circleId == null || circleId.isEmpty) return null;
  await StorageUtil.remove(pendingCircleShareKey);
  return circleId;
}

class JoinCircleQrHandler {
  void handle(BuildContext context, String code) {
    String? circleId;
    final value = code.trim();
    if (value.startsWith('{')) {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>? ?? {};
      circleId = payload['circleId'] as String?;
    } else {
      circleId = parseCircleIdFromShare(value);
    }

    if (circleId == null || circleId.isEmpty) return;

    final uri = Uri(
      path: AppRoutes.circleJoin,
      queryParameters: {'circleId': circleId},
    );
    context.push(uri.toString());
  }
}

final joinCircleQrHandler = JoinCircleQrHandler();
