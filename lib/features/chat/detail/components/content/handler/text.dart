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
        // TODO: Implement recall API via Business layer
        print('Recall message: ${message.id}');
        break;
      case 'delete':
        // TODO: Implement delete API via Business layer
        print('Delete message: ${message.id}');
        break;
    }
  }

  @override
  List<String> getSupportedCommands() {
    return ['copy', 'reply', 'forward', 'multiSelect', 'recall', 'delete'];
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
      items.insert(items.length - 1, BaseMessageHandler.recallAction);
    }
    return items;
  }
}
