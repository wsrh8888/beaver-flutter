import 'package:beaver/features/groupList/group_list_page/data/models/group.dart';

class GroupListRepository {
  Future<List<GroupInfo>> getGroupList() async {
    // 模拟获取群聊列表
    await Future.delayed(const Duration(seconds: 1));
    return [
      GroupInfo(
        conversationId: 'group_1',
        title: '技术交流群',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=tech%20group%20avatar&size=512x512',
        lastMessage: '大家好，欢迎加入技术交流群！',
        memberCount: 45,
      ),
      GroupInfo(
        conversationId: 'group_2',
        title: '产品讨论组',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=product%20group%20avatar&size=512x512',
        lastMessage: '下周一我们讨论新功能',
        memberCount: 12,
      ),
      GroupInfo(
        conversationId: 'group_3',
        title: '设计分享群',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=design%20group%20avatar&size=512x512',
        lastMessage: '这是我最新的设计作品',
        memberCount: 28,
      ),
    ];
  }
}
