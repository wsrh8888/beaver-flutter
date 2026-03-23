import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/contact.dart';

class NewFriendsRepository {
  final _friendBusiness = getIt<FriendBusiness>();

  Future<List<FriendRequest>> getFriendRequests() async {
    return await _friendBusiness.getFriendRequests();
  }

  Future<bool> updateRequestStatus(int id, int status) async {
    return await _friendBusiness.updateFriendRequestStatus(id, status);
  }
}

