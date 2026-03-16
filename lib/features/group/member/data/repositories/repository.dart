import 'package:beaver/features/group/member/data/models/member.dart';

class GroupMemberRepository {
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    // 模拟获取群成�?
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

  Future<List<Contact>> getContacts() async {
    // 模拟获取联系人列�?
    await Future.delayed(const Duration(seconds: 1));
    return [
      Contact(
        userId: '4',
        nickname: '赵六',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%204&size=512x512',
      ),
      Contact(
        userId: '5',
        nickname: '钱七',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%205&size=512x512',
      ),
    ];
  }

  Future<bool> addGroupMembers(String groupId, List<String> userIds) async {
    // 模拟添加群成�?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> removeGroupMembers(String groupId, List<String> userIds) async {
    // 模拟移除群成�?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

