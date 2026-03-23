import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';

class AudioHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(String commandId, MessageModel message) async {
    switch (commandId) {
      case 'play':
        print('Play audio: ${message.content}');
        break;
      case 'recall':
        print('Recall audio: ${message.id}');
        break;
      case 'delete':
        print('Delete audio: ${message.id}');
        break;
    }
  }

  @override
  List<String> getSupportedCommands() {
    return ['play', 'transferToText', 'reply', 'forward', 'multiSelect', 'recall', 'delete'];
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
