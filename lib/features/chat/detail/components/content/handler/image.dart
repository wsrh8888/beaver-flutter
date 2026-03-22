import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';

class ImageHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(String commandId, MessageModel message) async {
    // TODO: Implement image specific commands
  }

  @override
  List<String> getSupportedCommands() {
    return ['reply', 'forward', 'multiSelect', 'recall', 'delete'];
  }

  @override
  List<MessageAction> getMenuItems(MessageModel message) {
    return [
      BaseMessageHandler.replyAction,
      BaseMessageHandler.forwardAction,
      BaseMessageHandler.saveToEmojiAction,
      BaseMessageHandler.deleteAction,
      BaseMessageHandler.multiSelectAction,
    ];
  }
}
