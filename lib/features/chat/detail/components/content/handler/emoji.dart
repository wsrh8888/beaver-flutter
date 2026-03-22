import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';

class EmojiHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(String commandId, MessageModel message) async {
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
