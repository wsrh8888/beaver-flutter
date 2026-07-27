import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/router/routes.dart';

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

String buildGroupShareLink(String groupId) {
  final id = groupId.startsWith('group_')
      ? groupId.substring('group_'.length)
      : groupId;
  return 'beaver://share/group/$id';
}

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
    String? groupId;
    final value = code.trim();
    if (value.startsWith('{')) {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>? ?? {};
      groupId = payload['groupId'] as String?;
    } else {
      groupId = parseGroupIdFromShare(value);
    }

    if (groupId == null || groupId.isEmpty) return;

    final conversationId =
        groupId.startsWith('group_') ? groupId : 'group_$groupId';
    context.push('${AppRoutes.groupConfig}?id=$conversationId');
  }
}

final joinGroupQrHandler = JoinGroupQrHandler();
