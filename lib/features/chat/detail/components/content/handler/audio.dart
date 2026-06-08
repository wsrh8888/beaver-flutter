import 'package:beaver/di/injection.dart';
import 'package:beaver/store/voice/voice.dart';
import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/widgets.dart';

class AudioHandler extends BaseMessageHandler {
  @override
  Future<void> handleCommand(BuildContext context, String commandId, MessageModel message) async {
    switch (commandId) {
      case 'play':
        if (message.msg.audioFileMsg != null) {
          await getIt<VoicePlayerStore>().toggle(message.msg.audioFileMsg!.fileUrl);
        }
        break;
      case 'recall':
        await recallMessage(context, message);
        break;
      case 'delete':
        await deleteMessage(context, message);
        break;
    }
  }

  @override
  List<String> getSupportedCommands() {
    return [
      'play',
      'transferToText',
      'reply',
      'forward',
      'multiSelect',
      'recall',
      'delete',
    ];
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
