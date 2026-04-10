import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/widgets.dart';

class EmojiHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(BuildContext context, String commandId, MessageModel message) async {
    // TODO: Implement emoji specific commands
  }

  @override
  List<String> getSupportedCommands() {
    return ['reply', 'multiSelect', 'recall', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    return [BaseMessageHandler.favoriteAction];
  }
}
