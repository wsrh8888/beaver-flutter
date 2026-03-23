import 'package:beaver/features/user/config/data/models/config.dart';

class UserConfigRepository {
  Future<FriendInfo> getFriendInfo(String conversationId) async {
    // 模拟获取好友信息
    await Future.delayed(const Duration(seconds: 1));
    return FriendInfo(
      userId: '123456',
      nickname: '张三',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
      isOnline: true,
    );
  }

  Future<bool> toggleTopChat(String conversationId, bool isPinned) async {
    // 模拟置顶聊天
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> deleteFriend(String friendId) async {
    // 模拟删除好友
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

