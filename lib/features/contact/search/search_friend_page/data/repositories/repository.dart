import 'package:beaver/features/searchFriend/search_friend_page/data/models/search.dart';

class SearchFriendRepository {
  Future<SearchResult?> searchUser(String email) async {
    // 模拟搜索用户
    await Future.delayed(const Duration(seconds: 1));
    // 模拟找到用户
    return SearchResult(
      userId: '123456',
      nickname: '李四',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
      abstract: '这个人很懒，什么都没写~',
      notice: '欢迎添加好友',
      isFriend: false,
      conversationId: '',
      email: email,
    );
  }

  Future<bool> sendFriendRequest(String friendId, String message, String source) async {
    // 模拟发送好友请求
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
