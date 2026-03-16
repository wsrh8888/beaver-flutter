import 'package:beaver/features/createGroup/create_group_page/data/models/contact.dart';

class CreateGroupRepository {
  Future<List<Contact>> getContacts() async {
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

  Future<String> createGroup(List<String> userIds) async {
    // 模拟创建群组
    await Future.delayed(const Duration(seconds: 1));
    return 'group_${DateTime.now().millisecondsSinceEpoch}';
  }
}
