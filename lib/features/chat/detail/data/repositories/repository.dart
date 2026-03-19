import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/message.dart';

class ChatRepository {
  final MessageBusiness _messageBusiness = getIt<MessageBusiness>();

  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    return _messageBusiness.getMessages(conversationId, limit: limit, offset: offset);
  }

  Future<MessageModel> sendMessage(String conversationId, String content, MessageType type) async {
    return _messageBusiness.sendMessage(conversationId, content, type);
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    return _messageBusiness.updateMessageStatus(messageId, status);
  }

  Future<dynamic> getConversation(String conversationId) async {
    return _messageBusiness.getConversation(conversationId);
  }

  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return _messageBusiness.watchMessages(conversationId);
  }
}
