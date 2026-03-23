import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user.dart';

class SearchContactRepository {
  final FriendRepositoryInterface _friendRepository;

  SearchContactRepository({FriendRepositoryInterface? friendRepository}) 
    : _friendRepository = friendRepository ?? getIt<FriendRepositoryInterface>();

  Future<UserInfo?> searchUser(String email) async {
    return _friendRepository.searchUser(email);
  }

  Future<bool> addFriend(String userId) async {
    return _friendRepository.addFriend(userId);
  }
}
