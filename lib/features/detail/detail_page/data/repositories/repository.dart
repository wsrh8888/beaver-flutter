import 'package:beaver/features/detail/detail_page/data/models/user_info.dart';

class DetailRepository {
  Future<UserInfo> getUserInfo(String userId) async {
    // 模拟获取用户信息
    await Future.delayed(const Duration(seconds: 1));
    return UserInfo(
      userId: userId,
      nickname: '张三',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait&size=512x512',
      remarkName: '张总',
      signature: '这个人很懒，什么都没写~',
      gender: 'male',
      location: '北京市',
      age: '25',
      constellation: '白羊座',
      occupation: '软件工程师',
      education: '本科',
      hobbies: '编程、篮球、音乐',
      photos: [
        'https://neeko-copilot.bytedance.net/api/text2image?prompt=landscape%20photo&size=512x512',
        'https://neeko-copilot.bytedance.net/api/text2image?prompt=portrait%20photo&size=512x512',
        'https://neeko-copilot.bytedance.net/api/text2image?prompt=food%20photo&size=512x512',
      ],
      conversationId: 'conv_$userId',
      source: 'search',
    );
  }

  Future<bool> updateRemarkName(String userId, String remarkName) async {
    // 模拟更新备注名称
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> deleteFriend(String userId) async {
    // 模拟删除好友
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
