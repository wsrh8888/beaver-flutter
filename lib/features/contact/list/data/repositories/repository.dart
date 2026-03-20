import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';

class ContactListRepository {
  final FriendRepositoryInterface _friendRepository;

  ContactListRepository({FriendRepositoryInterface? friendRepository}) 
    : _friendRepository = friendRepository ?? getIt<FriendRepositoryInterface>();

  Future<List<ContactModel>> getContactList() async {
    return _friendRepository.getContactList();
  }

  // 根据字母分组联系人
  Map<String, List<ContactModel>> groupContactsByLetter(List<ContactModel> contacts) {
    return _friendRepository.groupContactsByLetter(contacts);
  }

  // 获取索引列表
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    return _friendRepository.getIndexList(groups);
  }
}