import 'package:beaver/core/database/services/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/message.dart';

/// 聊天消息业务逻辑
class MessageBusiness implements MessageRepositoryInterface {
  final _messageService = getIt<ChatMessageService>();

  /**
   * @description 获取消息列表
   */
  Future<List<MessageModel>> getMessages(String conversationId, {int limit = 50, int offset = 0}) async {
    // 模拟数据
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      MessageModel(
        id: '1',
        conversationId: conversationId,
        userId: 'user1',
        content: '你好！',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isSent: false,
      ),
      MessageModel(
        id: '2',
        conversationId: conversationId,
        userId: 'currentUser',
        content: '你好，有什么可以帮你的？',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        isSent: true,
      ),
    ];
  }

  /**
   * @description 发送消息
   */
  Future<MessageModel> sendMessage(String conversationId, String content, MessageType type) async {
    // 模拟发送
    await Future.delayed(const Duration(milliseconds: 500));
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      userId: 'currentUser',
      content: content,
      type: type,
      status: MessageStatus.sent,
      createdAt: DateTime.now(),
      isSent: true,
    );
  }

  /**
   * @description 更新消息状态
   */
  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    // 模拟更新
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /**
   * @description 获取会话信息
   */
  Future<Map<String, dynamic>> getConversation(String conversationId) async {
    // 模拟数据
    return {
      'conversationId': conversationId,
      'title': '测试会话',
      'avatar': '',
    };
  }

  /**
   * @description 监听消息变化
   */
  Stream<List<MessageModel>> watchMessages(String conversationId) {
    // 模拟流
    return Stream.periodic(const Duration(seconds: 5), (_) => []);
  }

  /// 清除特定消息的计时器 (ACK 确认后)
  void clearTimers(List<String> messageIds) {
    // TODO: 实现消息发送状态管理和超时计时器
    print('[MessageBusiness] 清除消息计时器: ${messageIds.length} 条');
  }
}