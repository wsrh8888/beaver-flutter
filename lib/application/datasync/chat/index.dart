import 'conversation_meta_sync.dart';
import 'message_sync.dart';
import 'user_conversation_sync.dart';

final messageSync = MessageSync();
final conversationMetaSync = ConversationMetaSync();
final userConversationSync = UserConversationSync();

class ChatDatasync {
  Future<void> checkAndSync() async {
    await Future.wait([
      userConversationSync.checkAndSync(),
      conversationMetaSync.checkAndSync(),
      messageSync.checkAndSync(),
    ]);
  }
}

final chatDatasync = ChatDatasync();
