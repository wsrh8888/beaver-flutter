import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';

/// 处理二维码扫码结果
void handleQrCode(BuildContext context, String code) {
  try {
    // 优先尝试解析 JSON
    if (code.startsWith('{') && code.endsWith('}')) {
      final Map<String, dynamic> data = jsonDecode(code);
      final String? action = data['action'];
      final Map<String, dynamic>? payload = data['payload'];

      if (action == 'addFriend' && payload != null) {
        final String? userId = payload['userId'];
        if (userId != null && userId.isNotEmpty) {
          // 跳转到用户资料详情页
          context.push('/contact/detail/$userId');
          return;
        }
      }

      if (action == 'joinGroup' && payload != null) {
        final String? groupId = payload['groupId'];
        if (groupId != null && groupId.isNotEmpty) {
          // 跳转到群组相关页面，暂定进入群详情
          context.push('${AppRoutes.groupConfig}?id=$groupId');
          return;
        }
      }
    }

    // 如果是 URL，且不是我们的 JSON 协议，则打开 WebView
    if (code.startsWith('http://') || code.startsWith('https://')) {
      context.push('${AppRoutes.webview}?url=${Uri.encodeComponent(code)}');
      return;
    }

    // 默认作为纯文本显示或提示无效
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('扫码结果: $code')),
    );
  } catch (e) {
    // 如果解析 JSON 失败，且是 URL 则打开 URL
    if (code.startsWith('http://') || code.startsWith('https://')) {
      context.push('${AppRoutes.webview}?url=${Uri.encodeComponent(code)}');
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('无效的二维码')),
    );
  }
}
