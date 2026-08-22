import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/invite/invite.dart';
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
  if (isCircleInviteUrl(value)) return true;
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

/// 兼容旧版客户端拼装链接（新链路请用服务端 inviteUrl）
String buildCircleShareLink(String circleId) {
  return 'beaver://share/circle/$circleId';
}

/// 兼容旧版 JSON 二维码；正式分享请直接用 inviteUrl 作为二维码内容
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
    final value = code.trim();

    // 正式邀请链接：带 inviteCode
    final invite = parseInviteRef(value);
    if (invite != null && invite.kind == InviteKind.circle) {
      _openJoin(
        context,
        queryParameters: {'inviteCode': invite.code},
      );
      return;
    }

    String? circleId;
    if (value.startsWith('{')) {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>? ?? {};
      circleId = payload['circleId'] as String?;
      final token = payload['inviteToken'] as String? ??
          payload['inviteCode'] as String?;
      if (token != null && token.isNotEmpty) {
        _openJoin(
          context,
          queryParameters: {
            if (circleId != null && circleId.isNotEmpty) 'circleId': circleId,
            'inviteCode': token,
          },
        );
        return;
      }
    } else {
      circleId = parseCircleIdFromShare(value);
    }

    if (circleId == null || circleId.isEmpty) return;

    _openJoin(
      context,
      queryParameters: {'circleId': circleId},
    );
  }

  void _openJoin(
    BuildContext context, {
    required Map<String, String> queryParameters,
  }) {
    final uri = Uri(
      path: AppRoutes.circleJoin,
      queryParameters: queryParameters,
    );
    context.replace(uri.toString());
  }
}

final joinCircleQrHandler = JoinCircleQrHandler();
