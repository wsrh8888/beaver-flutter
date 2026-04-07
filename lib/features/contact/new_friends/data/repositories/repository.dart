import 'package:beaver/api/friend.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/types/business/contact.dart';

class NewFriendsRepository {
  final _friendBusiness = getIt<FriendBusiness>();

  Future<List<FriendRequest>> getFriendRequests() async {
    return await _friendBusiness.getFriendRequests();
  }

  /// 直接调用接口验证好友申请，返回 API 原生 Response
  Future<BaseResponse<void>> updateRequestStatus(
    String verifyId,
    int status,
  ) async {
    return await valiFriendApi(
      IValiFriendReq(verifyId: verifyId, status: status),
    );
  }
}
