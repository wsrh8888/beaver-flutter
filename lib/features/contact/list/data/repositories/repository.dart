import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';

class ContactListRepository {
  final FriendBusiness _friendBusiness = getIt<FriendBusiness>();

  Future<List<ContactModel>> getContactList() async {
    return _friendBusiness.getContactList();
  }

  // 根据字母分组联系人
  Map<String, List<ContactModel>> groupContactsByLetter(List<ContactModel> contacts) {
    return _friendBusiness.groupContactsByLetter(contacts);
  }

  // 获取索引列表
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    return _friendBusiness.getIndexList(groups);
  }
}