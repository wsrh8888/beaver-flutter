import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TextHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(
    BuildContext context,
    String commandId,
    MessageModel message,
  ) async {
    switch (commandId) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.content));
        break;
      case 'recall':
        await recallMessage(context, message);
        break;
      case 'edit':
        startEditMessage(context, message);
        break;
      case 'delete':
        await deleteMessage(context, message);
        break;
    }
  }

  @override
  List<String> getSupportedCommands() {
    return ['copy', 'reply', 'forward', 'multiSelect', 'edit', 'recall', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    final items = [
      BaseMessageHandler.copyAction,
      BaseMessageHandler.replyAction,
      BaseMessageHandler.forwardAction,
      BaseMessageHandler.multiSelectAction,
      BaseMessageHandler.deleteAction,
    ];
    if (message.isSent) {
      if (canEditMessage(message)) {
        items.insert(items.length - 1, BaseMessageHandler.editAction);
      }
      items.insert(items.length - 1, BaseMessageHandler.recallAction);
    }
    return items;
  }
}
