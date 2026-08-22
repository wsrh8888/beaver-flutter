import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/invite/invite.dart';

bool isJoinGroupQr(String code) {
  final value = code.trim();
  if (value.startsWith('{')) {
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      return data['action'] == 'joinGroup';
    } catch (_) {
      return false;
    }
  }
  if (isGroupInviteUrl(value)) return true;
  return parseGroupIdFromShare(value) != null;
}

String? parseGroupIdFromShare(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null) {
    if (uri.scheme == 'beaver' &&
        uri.host == 'share' &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'group') {
      return uri.pathSegments[1];
    }
    if (uri.pathSegments.length >= 2) {
      final shareIndex = uri.pathSegments.indexOf('share');
      if (shareIndex >= 0 &&
          shareIndex + 2 < uri.pathSegments.length &&
          uri.pathSegments[shareIndex + 1] == 'group') {
        return uri.pathSegments[shareIndex + 2];
      }
    }
  }

  final match = RegExp(r'/share/group/([^/?#]+)').firstMatch(value);
  return match?.group(1);
}

/// 兼容旧版客户端拼装链接
String buildGroupShareLink(String groupId) {
  final id = groupId.startsWith('group_')
      ? groupId.substring('group_'.length)
      : groupId;
  return 'beaver://share/group/$id';
}

/// 兼容旧版 JSON 二维码
String buildGroupInviteQrValue(String groupId) {
  final id = groupId.startsWith('group_')
      ? groupId.substring('group_'.length)
      : groupId;
  return jsonEncode({
    'action': 'joinGroup',
    'appName': 'beaver',
    'version': AppConfig.version,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'expireAt': 0,
    'payload': {'groupId': id},
  });
}

class JoinGroupQrHandler {
  void handle(BuildContext context, String code) {
    final value = code.trim();

    final invite = parseInviteRef(value);
    if (invite != null && invite.kind == InviteKind.group) {
      _openJoin(
        context,
        queryParameters: {'inviteCode': invite.code},
      );
      return;
    }

    String? groupId;
    if (value.startsWith('{')) {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>? ?? {};
      groupId = payload['groupId'] as String?;
      final token = payload['inviteToken'] as String? ??
          payload['inviteCode'] as String?;
      if (token != null && token.isNotEmpty) {
        _openJoin(
          context,
          queryParameters: {
            if (groupId != null && groupId.isNotEmpty) 'groupId': groupId,
            'inviteCode': token,
          },
        );
        return;
      }
    } else {
      groupId = parseGroupIdFromShare(value);
    }

    if (groupId == null || groupId.isEmpty) return;

    _openJoin(
      context,
      queryParameters: {'groupId': groupId},
    );
  }

  void _openJoin(
    BuildContext context, {
    required Map<String, String> queryParameters,
  }) {
    final location = Uri(
      path: AppRoutes.groupJoin,
      queryParameters: queryParameters,
    ).toString();

    final router = GoRouter.of(context);
    // 先关闭扫码页，再打开加入页，保证返回能回到扫码前的界面
    if (router.canPop()) {
      router.pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.push(location);
      });
      return;
    }
    router.push(location);
  }
}

final joinGroupQrHandler = JoinGroupQrHandler();
