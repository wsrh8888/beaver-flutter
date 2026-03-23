import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/friend.dart';

/// 批量获取好友数据
Future<BaseResponse<IGetFriendsListByIdsRes>> getFriendsListByIdsApi(IGetFriendsListByIdsReq data) {
  const url = '/api/friend/getFriendsListByIds';
  return httpClient.post<IGetFriendsListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetFriendsListByIdsRes.fromJson(json));
}

/// 批量获取好友验证数据
Future<BaseResponse<IGetFriendVerifiesListByIdsRes>> getFriendVerifiesListByIdsApi(IGetFriendVerifiesListByIdsReq data) {
  const url = '/api/friend/getFriendVerifiesListByIds';
  return httpClient.post<IGetFriendVerifiesListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetFriendVerifiesListByIdsRes.fromJson(json));
}
