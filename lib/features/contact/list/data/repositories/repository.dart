import 'package:beaver/core/database/database.dart';
import 'package:beaver/features/contact/list/data/models/contact.dart';

class ContactListRepository {
  final AppDatabase _database;

  ContactListRepository(this._database);

  Future<List<ContactModel>> getContactList() async {
    // 从本地数据库获取好友列表
    final friends = await _database.select(_database.friends).get();

    return friends.map((friend) {
      return ContactModel(
        userId: friend.friendId,
        nickname: friend.sendUserNotice ?? friend.friendId,
        notice: friend.revUserNotice,
        avatar: '', // Table missing avatar
      );
    }).toList();
  }

  // 根据字母分组联系人
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

  // 获取索引列表
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    final letters = [''];
    letters.addAll(groups.keys.toList()..sort());
    return letters;
  }
}