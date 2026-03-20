import 'package:beaver/types/business/group.dart';

/// 群组业务逻辑
class GroupBusiness implements GroupRepositoryInterface {
  /**
   * @description 获取联系人列表
   */
  Future<List<Contact>?> getContacts() async {
    // 模拟获取联系人列表
    await Future.delayed(const Duration(seconds: 1));
    return [
      Contact(
        userId: '1',
        nickname: '张三',
        fileName: 'avatar1.jpg',
        status: '在线',
      ),
      Contact(
        userId: '2',
        nickname: '李四',
        fileName: 'avatar2.jpg',
        status: '离线',
      ),
      Contact(
        userId: '3',
        nickname: '王五',
        fileName: 'avatar3.jpg',
        status: '在线',
      ),
      Contact(
        userId: '4',
        nickname: '赵六',
        fileName: 'avatar4.jpg',
        status: '在线',
      ),
      Contact(
        userId: '5',
        nickname: '钱七',
        fileName: 'avatar5.jpg',
        status: '离线',
      ),
    ];
  }

  /**
   * @description 创建群组
   */
  Future<String> createGroup(List<String> userIds) async {
    // 模拟创建群组
    await Future.delayed(const Duration(seconds: 1));
    return 'group_${DateTime.now().millisecondsSinceEpoch}';
  }

  /**
   * @description 获取群组列表
   */
  Future<List<GroupInfo>?> getGroupList() async {
    return [
      const GroupInfo(
        conversationId: '1',
        title: '技术交流群',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=tech%20group%20avatar&size=512x512',
        lastMessage: '大家好，欢迎加入技术交流群！',
        memberCount: 45,
      ),
      const GroupInfo(
        conversationId: '2',
        title: '产品讨论组',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=product%20group%20avatar&size=512x512',
        lastMessage: '下周一我们讨论新功能。',
        memberCount: 12,
      ),
    ];
  }
}