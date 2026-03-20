import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';

class ChatListRepository {
  final ConversationRepositoryInterface _conversationRepository;

  ChatListRepository({ConversationRepositoryInterface? conversationRepository}) 
    : _conversationRepository = conversationRepository ?? getIt<ConversationRepositoryInterface>();

  Future<List<ChatModel>> getChatList() async {
    return _conversationRepository.getChatList();
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    return _conversationRepository.togglePinChat(conversationId, isPinned);
  }

  Future<void> deleteChat(String conversationId) async {
    return _conversationRepository.deleteChat(conversationId);
  }
}
