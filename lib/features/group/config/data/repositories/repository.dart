import 'package:beaver/features/group/config/data/models/config.dart';

class GroupConfigRepository {
  Future<GroupInfo> getGroupInfo(String groupId) async {
    // 模拟获取群组信息
    await Future.delayed(const Duration(seconds: 1));
    return GroupInfo(
      groupId: groupId,
      title: '测试群聊',
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=group%20avatar&size=512x512',
      memberCount: 5,
    );
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    // 模拟获取群组成员
    await Future.delayed(const Duration(seconds: 1));
    return [
      GroupMember(
        userId: '1',
        nickname: '张三',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%201&size=512x512',
        role: 2,
      ),
      GroupMember(
        userId: '2',
        nickname: '李四',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%202&size=512x512',
        role: 0,
      ),
      GroupMember(
        userId: '3',
        nickname: '王五',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%203&size=512x512',
        role: 1,
      ),
    ];
  }

  Future<bool> updateGroupName(String groupId, String name) async {
    // 模拟更新群名?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> quitGroup(String groupId) async {
    // 模拟退出群?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

