import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';

class CreateGroupRepository {
  final GroupRepositoryInterface _groupRepository;

  CreateGroupRepository({GroupRepositoryInterface? groupRepository}) 
    : _groupRepository = groupRepository ?? getIt<GroupRepositoryInterface>();

  Future<List<Contact>?> getContacts() async {
    return _groupRepository.getContacts();
  }

  Future<String> createGroup(List<String> userIds) async {
    return _groupRepository.createGroup(userIds);
  }
}

