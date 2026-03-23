import 'package:beaver/features/chat/detail/components/content/handler/base.dart';
import 'package:beaver/features/chat/detail/components/content/handler/text.dart';
import 'package:beaver/features/chat/detail/components/content/handler/audio.dart';
import 'package:beaver/features/chat/detail/components/content/handler/image.dart';
import 'package:beaver/features/chat/detail/components/content/handler/video.dart';
import 'package:beaver/features/chat/detail/components/content/handler/file.dart';
import 'package:beaver/features/chat/detail/components/content/handler/emoji.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/types/business/message.dart';

class MessageHandlerFactory {
  static BaseMessageHandler getHandler(MessageType type) {
    switch (type) {
      case MessageType.text:
        return TextHandler();
      case MessageType.audio:
      case MessageType.voice:
        return AudioHandler();
      case MessageType.image:
        return ImageHandler();
      case MessageType.video:
        return VideoHandler();
      case MessageType.file:
        return FileHandler();
      case MessageType.emoji:
        return EmojiHandler();
      case MessageType.mergedForward:
        return ForwardHandler();
      default:
        return TextHandler();
    }
  }

  static Future<void> handleCommand(String commandId, MessageModel message) async {
    final handler = getHandler(message.type);
    await handler.handleCommand(commandId, message);
  }
}
