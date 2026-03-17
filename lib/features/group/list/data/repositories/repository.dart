import 'package:beaver/features/group/list/data/models/group.dart';

class GroupListRepository {
  Future<List<GroupInfo>> getGroupList() async {
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
