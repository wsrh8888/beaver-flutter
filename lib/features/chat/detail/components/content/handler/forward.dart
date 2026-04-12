import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ForwardHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(BuildContext context, String commandId, MessageModel message) async {
    if (commandId == 'forward') {
      navigateToPicker(context, messageIds: [message.id]);
    }
  }

  /// 封装转发路由跳转逻辑
  static void navigateToPicker(
    BuildContext context, {
    required List<String> messageIds,
    int forwardMode = 1,
  }) {
    context.push(
      AppRoutes.chatForward,
      extra: {'messageIds': messageIds, 'forwardMode': forwardMode},
    );
  }

  @override
  List<String> getSupportedCommands() {
    return ['forward', 'multiSelect', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    return [
      BaseMessageHandler.forwardAction,
      BaseMessageHandler.multiSelectAction,
      BaseMessageHandler.deleteAction,
    ];
  }
}
