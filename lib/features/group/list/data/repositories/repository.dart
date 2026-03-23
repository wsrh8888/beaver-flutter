import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';

class GroupListRepository {
  final GroupRepositoryInterface _groupRepository;

  GroupListRepository({GroupRepositoryInterface? groupRepository}) 
    : _groupRepository = groupRepository ?? getIt<GroupRepositoryInterface>();

  Future<List<GroupInfo>?> getGroupList() async {
    return _groupRepository.getGroupList();
  }
}
