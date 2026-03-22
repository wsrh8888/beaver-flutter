import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:intl/intl.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user.dart';

/// 好友业务逻辑
class FriendBusiness implements FriendRepositoryInterface {
  final _service = getIt<FriendService>();

  /**
   * @description 获取好友列表 (UI 格式)
   */
  Future<List<ContactModel>> getContactList() async {
    final friends = await _service.getFriends();
    print('FriendBusiness: 1. 从数据库读取到原始好友记录: ${friends.length} 条');
    if (friends.isEmpty) return [];

    final myUserId = DatabaseManager.currentUserId ?? '';
    if (myUserId.isEmpty) {
      print('FriendBusiness: [警告] currentUserId 为空，无法正确解析好友关系');
      return [];
    }

    // 确定好友的用户ID列表 (用于批量查询资料)
    final friendUserIds = friends.map((f) {
      return f.sendUserId == myUserId ? f.revUserId : f.sendUserId;
    }).toList();

    final userBusiness = getIt<UserBusiness>();

    // 批量获取这些好友的基础资料 (从 users 表)
    final userInfos = await userBusiness.getUsersBasicInfo(friendUserIds);
    print('FriendBusiness: 2. 获取到用户基础资料元数据: ${userInfos.length} 条');

    final userMap = {for (var u in userInfos) u.userId: u};

    final results = friends.map((friend) {
      // 确定好友的用户ID
      final friendUserId = friend.sendUserId == myUserId
          ? friend.revUserId
          : friend.sendUserId;

      final userInfo = userMap[friendUserId];
      if (userInfo == null) {
        print('FriendBusiness: [警告] 找不到好友 $friendUserId 的基础资料');
      }

      // 确定备注信息 (根据我是发送者还是接收者)
      final notice = friend.sendUserId == myUserId
          ? friend.sendUserNotice
          : friend.revUserNotice;

      return ContactModel(
        userId: friendUserId,
        nickname: userInfo?.nickname ?? '',
        notice: notice,
        avatar: userInfo?.avatar ?? '',
      );
    }).toList();

    // 2、打印 getContactList 的值
    print('FriendBusiness: 3. getContactList 组装结果共有 ${results.length} 条:');
    for (var item in results) {
      print(
        '  - userId: ${item.userId}, nickname: ${item.nickname}, notice: ${item.notice}',
      );
    }

    return results;
  }

  /**
   * @description 根据字母分组联系人
   */
  Map<String, List<ContactModel>> groupContactsByLetter(
    List<ContactModel> contacts,
  ) {
    final groups = <String, List<ContactModel>>{};

    for (final contact in contacts) {
      // 优先使用备注 (notice) 进行分组
      final displayName = contact.notice?.isNotEmpty == true
          ? contact.notice!
          : contact.nickname;
      final firstChar = displayName.isNotEmpty
          ? displayName[0].toUpperCase()
          : '#';
      final letter = RegExp(r'[A-Z]').hasMatch(firstChar) ? firstChar : '#';

      if (!groups.containsKey(letter)) {
        groups[letter] = [];
      }
      groups[letter]!.add(contact);
    }

    // 处理排序：优先使用备注排序
    groups.forEach((key, value) {
      value.sort((a, b) {
        final aName = a.notice?.isNotEmpty == true ? a.notice! : a.nickname;
        final bName = b.notice?.isNotEmpty == true ? b.notice! : b.nickname;
        return aName.compareTo(bName);
      });
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
      avatar:
          'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
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

  @override
  Future<List<FriendRequest>> getFriendRequests() async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) return [];

    final verifyService = getIt<FriendVerifyService>();
    final userBusiness = getIt<UserBusiness>();

    // 1. 获取验证记录
    final verifies = await verifyService.getValidList(currentUserId);
    if (verifies.isEmpty) return [];

    // 2. 收集需要查询的用户ID
    final userIds = verifies.map((v) {
      return v.sendUserId == currentUserId ? v.revUserId : v.sendUserId;
    }).toSet().toList();

    // 3. 批量获取用户信息
    final userInfos = await userBusiness.getUsersBasicInfo(userIds);
    final userMap = {for (var u in userInfos) u.userId: u};

    // 4. 组装数据
    final requests = verifies.map((v) {
      final friendUserId = v.sendUserId == currentUserId ? v.revUserId : v.sendUserId;
      final userInfo = userMap[friendUserId];
      final flag = v.sendUserId == currentUserId ? 'send' : 'receive';
      
      int status = (v.revStatus == 1 || v.sendStatus == 1) ? 1 : (v.revStatus == 2 || v.sendStatus == 2 ? 2 : 0);

      final createdAt = v.createdAt != null 
          ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(v.createdAt! * 1000))
          : '';

      return FriendRequest(
        id: v.id,
        nickname: userInfo?.nickname ?? friendUserId,
        fileName: userInfo?.avatar ?? '',
        message: v.message,
        source: v.source ?? 'search',
        flag: flag,
        status: status,
        createdAt: createdAt,
      );
    }).toList();

    // 按时间降序排序
    requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return requests;
  }

  @override
  Future<int> getUnreadFriendRequestCount(String userId) async {
    final verifyService = getIt<FriendVerifyService>();
    return await verifyService.getUnreadCount(userId);
  }

  @override
  Future<bool> updateFriendRequestStatus(int id, int status) async {
    // TODO: 调用 API 同步状态到服务器，并更新本地数据库
    return true;
  }

  /**
   * @description 处理好友表更新
   */
  Future<void> handleTableUpdates(int version, String? friendId) async {
    print('[FriendBusiness] 处理好友表更新: friendId=$friendId, version=$version');
    // TODO: 实现具体的更新逻辑 (如清理缓存、重新拉取数据等)
  }
}
