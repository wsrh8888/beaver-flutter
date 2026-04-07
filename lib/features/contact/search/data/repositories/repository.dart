import 'package:beaver/api/friend.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/types/business/user.dart';

class SearchContactRepository {
  Future<UserInfo?> searchUser(String keyword) async {
    final response = await getSearchFriendApi(
      ISearchUserReq(
        keyword: keyword,
        type: keyword.contains('@') ? 'email' : 'userId',
      ),
    );

    if (response.code != 0 || response.result == null) {
      return null;
    }

    final res = response.result!;
    return UserInfo(
      userId: res.userId,
      nickname: res.nickName,
      avatar: res.avatar,
      abstract: res.abstract,
      email: res.email,
    );
  }

  Future<BaseResponse<void>> addFriend(String userId) async {
    return applyAddFriendApi(
      IAddFriendReq(friendId: userId, source: 'userId', verify: 'verify'),
    );
  }
}
