import 'package:beaver/features/common/select_conversation/select_conversation_page.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 打开选择会话页
///
/// - [payload] 不为空：发送消息模式，成功返回 `true`
/// - [payload] 为空：选择模式，返回 [ChatModel]
Future<T?> openSelectConversation<T>(
  BuildContext context, {
  String title = '选择会话',
  Map<String, dynamic>? payload,
}) {
  if (payload != null) {
    return context.push<T>(
      AppRoutes.selectConversation,
      extra: {
        'title': title,
        'payload': payload,
      },
    );
  }

  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (_) => SelectConversationPage(title: title),
    ),
  );
}
