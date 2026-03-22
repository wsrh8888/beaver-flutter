import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';

class ForwardHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(String commandId, MessageModel message) async {
    // TODO: Implement forward specific commands
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
