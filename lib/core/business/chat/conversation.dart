import 'package:beaver/core/database/services/chat/chat.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';

/// 会话业务逻辑
class ConversationBusiness {
  final _service = getIt<ChatService>();

  /**
   * @description 获取会话列表 (UI 格式)
   */
  Future<List<ChatModel>> getChatList() async {
    final conversations = await _service.getConversations();

    return conversations.map((conv) {
      return ChatModel(
        conversationId: conv.conversationId,
        nickname: conv.title ?? '未知用户',
        avatar: conv.avatar,
        msgPreview: conv.lastMessage ?? '',
        updateAt: _formatTime(conv.updatedAt != null ? DateTime.fromMillisecondsSinceEpoch(conv.updatedAt!) : null),
        isTop: false, // TODO: Wait for services/DB to fully support isPinned
        unreadCount: 0,
      );
    }).toList();
  }

  /**
   * @description 标记会话为已读
   */
  Future<void> markAsRead(String conversationId) async {
    await _service.markAsRead(conversationId);
  }

  /**
   * @description 置顶会话
   */
  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    await _service.togglePinConversation(conversationId, isPinned);
  }

  /**
   * @description 删除会话
   */
  Future<void> deleteChat(String conversationId) async {
    await _service.deleteConversation(conversationId);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return '昨天';
    } else if (now.difference(dateTime).inDays < 7) {
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}