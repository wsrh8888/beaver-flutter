import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

bool isAddFriendQr(String code) {
  if (!code.startsWith('{')) {
    return false;
  }
  final data = jsonDecode(code) as Map<String, dynamic>;
  return data['action'] == 'addFriend';
}

class AddFriendQrHandler {
  void handle(BuildContext context, String code) {
    final data = jsonDecode(code) as Map<String, dynamic>;
    final payload = data['payload'] as Map<String, dynamic>;
    final userId = payload['userId'] as String;
    context.replace('/contact/detail/$userId');
  }
}

final addFriendQrHandler = AddFriendQrHandler();
