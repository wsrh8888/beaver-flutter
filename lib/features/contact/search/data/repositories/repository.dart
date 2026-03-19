import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/user.dart';

class SearchContactRepository {
  final FriendBusiness _friendBusiness = getIt<FriendBusiness>();

  Future<UserInfo?> searchUser(String email) async {
    return _friendBusiness.searchUser(email);
  }

  Future<bool> addFriend(String userId) async {
    return _friendBusiness.addFriend(userId);
  }
}
