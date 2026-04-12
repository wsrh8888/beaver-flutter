import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/widgets.dart';

class VideoHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(
    BuildContext context,
    String commandId,
    MessageModel message,
  ) async {
    // TODO: Implement video specific commands
  }

  @override
  List<String> getSupportedCommands() {
    return ['reply', 'forward', 'multiSelect', 'recall', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    final items = [
      BaseMessageHandler.replyAction,
      BaseMessageHandler.forwardAction,
      BaseMessageHandler.multiSelectAction,
    ];
    if (message.isSent) {
      items.add(BaseMessageHandler.recallAction);
    }
    items.add(BaseMessageHandler.deleteAction);
    return items;
  }
}
