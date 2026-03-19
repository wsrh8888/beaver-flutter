import 'package:beaver/features/contact/new_friends/data/models/friend_request.dart';

class NewFriendsRepository {
  Future<List<FriendRequest>> getFriendRequests() async {
    // 模拟获取好友申请列表
    await Future.delayed(const Duration(seconds: 1));
    return [
      FriendRequest(
        id: 1,
        nickname: '李四',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
        message: '你好，我是张三的朋友',
        source: 'search',
        flag: 'receive',
        status: 0,
        createdAt: '2024-01-01 10:00',
      ),
      FriendRequest(
        id: 2,
        nickname: '王五',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%202&size=512x512',
        message: '我们在同一个群',
        source: 'group',
        flag: 'receive',
        status: 1,
        createdAt: '2024-01-01 09:30',
      ),
      FriendRequest(
        id: 3,
        nickname: '赵六',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%203&size=512x512',
        message: '通过二维码添加',
        source: 'qrcode',
        flag: 'send',
        status: 0,
        createdAt: '2024-01-01 08:00',
      ),
    ];
  }

  Future<bool> updateRequestStatus(int id, int status) async {
    // 模拟更新申请状态
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

