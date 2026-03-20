import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/message.dart';

class ChatRepository {
  final MessageRepositoryInterface _messageRepository;

  ChatRepository({MessageRepositoryInterface? messageRepository}) 
    : _messageRepository = messageRepository ?? getIt<MessageRepositoryInterface>();

  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    return _messageRepository.getMessages(conversationId, limit: limit, offset: offset);
  }

  Future<MessageModel> sendMessage(String conversationId, String content, MessageType type) async {
    return _messageRepository.sendMessage(conversationId, content, type);
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    return _messageRepository.updateMessageStatus(messageId, status);
  }

  Future<dynamic> getConversation(String conversationId) async {
    return _messageRepository.getConversation(conversationId);
  }

  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return _messageRepository.watchMessages(conversationId);
  }
}
