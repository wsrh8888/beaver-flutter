import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/chat/chat_list/data/models/chat.dart';

class ChatListRepository {
  final AppDatabase _database;

  ChatListRepository(this._database);

  Future<List<ChatModel>> getChatList() async {
    // 从本地数据库获取会话列表
    final conversations = await _database.select(_database.conversations).get();

    return conversations.map((conv) {
      return ChatModel(
        conversationId: conv.id,
        nickname: conv.name ?? '未知用户',
        avatar: conv.avatar,
        msgPreview: conv.lastMessage ?? '',
        updateAt: _formatTime(conv.updatedAt),
        isTop: conv.isPinned ?? false,
        unreadCount: conv.unreadCount ?? 0,
      );
    }).toList();
  }

  Future<void> togglePinChat(String conversationId, bool isPinned) async {
    await _database.update(_database.conversations)
      ..where((c) => c.id.equals(conversationId))
      ..write(ConversationsCompanion(
        isPinned: Value(isPinned),
      ));
  }

  Future<void> deleteChat(String conversationId) async {
    await _database.delete(_database.conversations)
      ..where((c) => c.id.equals(conversationId));
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      // 今天，显示时间
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      // 昨天
      return '昨天';
    } else if (now.difference(dateTime).inDays < 7) {
      // 一周内，显示星期几
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      return weekdays[dateTime.weekday - 1];
    } else {
      // 超过一周，显示日期
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
