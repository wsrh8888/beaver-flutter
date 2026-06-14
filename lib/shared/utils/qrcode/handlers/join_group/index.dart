import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';

bool isJoinGroupQr(String code) {
  if (!code.startsWith('{')) {
    return false;
  }
  final data = jsonDecode(code) as Map<String, dynamic>;
  return data['action'] == 'joinGroup';
}

class JoinGroupQrHandler {
  void handle(BuildContext context, String code) {
    final data = jsonDecode(code) as Map<String, dynamic>;
    final payload = data['payload'] as Map<String, dynamic>;
    final groupId = payload['groupId'] as String;
    context.replace('${AppRoutes.groupConfig}?id=$groupId');
  }
}

final joinGroupQrHandler = JoinGroupQrHandler();
