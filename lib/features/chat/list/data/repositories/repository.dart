import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';

class ChatListRepository {
  final ConversationBusiness _conversationBusiness = getIt<ConversationBusiness>();

  Future<List<ChatModel>> getChatList() async {
    return _conversationBusiness.getChatList();
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    return _conversationBusiness.togglePinChat(conversationId, isPinned);
  }

  Future<void> deleteChat(String conversationId) async {
    return _conversationBusiness.deleteChat(conversationId);
  }
}
