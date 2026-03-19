import 'package:beaver/core/database/services/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user.dart';

/// 好友业务逻辑
class FriendBusiness {
  final _service = getIt<FriendService>();

  /**
   * @description 获取好友列表 (UI 格式)
   */
  Future<List<ContactModel>> getContactList() async {
    final friends = await _service.getFriends();

    return friends.map((friend) {
      return ContactModel(
        userId: friend.friendId,
        nickname: friend.sendUserNotice ?? friend.friendId,
        notice: friend.revUserNotice,
        avatar: '', // TODO: Handle avatar
      );
    }).toList();
  }

  /**
   * @description 根据字母分组联系人
   */
  Map<String, List<ContactModel>> groupContactsByLetter(List<ContactModel> contacts) {
    final groups = <String, List<ContactModel>>{};

    for (final contact in contacts) {
      final firstChar = contact.nickname.isNotEmpty
          ? contact.nickname[0].toUpperCase()
          : '#';
      final letter = RegExp(r'[A-Z]').hasMatch(firstChar) ? firstChar : '#';

      if (!groups.containsKey(letter)) {
        groups[letter] = [];
      }
      groups[letter]!.add(contact);
    }

    // 对每个分组内的联系人按名字排序
    groups.forEach((key, value) {
      value.sort((a, b) => a.nickname.compareTo(b.nickname));
    });

    return groups;
  }

  /**
   * @description 获取索引列表
   */
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    final letters = [''];
    letters.addAll(groups.keys.toList()..sort());
    return letters;
  }

  /**
   * @description 删除好友
   */
  Future<void> deleteFriend(String friendId) async {
    await _service.deleteFriend(friendId);
  }

  /**
   * @description 搜索用户
   */
  Future<UserInfo?> searchUser(String email) async {
    // 模拟搜索用户
    await Future.delayed(const Duration(seconds: 1));
    return const UserInfo(
      userId: '123456',
      nickname: '李四',
      avatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
    );
  }

  /**
   * @description 添加好友
   */
  Future<bool> addFriend(String userId) async {
    // 模拟发送好友请求
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}