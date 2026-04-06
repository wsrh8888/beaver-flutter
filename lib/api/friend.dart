import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/friend.dart';

/// 批量获取好友数据
Future<BaseResponse<IGetFriendsListByIdsRes>> getFriendsListByIdsApi(
  IGetFriendsListByIdsReq data,
) {
  const url = '/api/friend/getFriendsListByIds';
  return httpClient.post<IGetFriendsListByIdsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetFriendsListByIdsRes.fromJson(json),
  );
}

/// 批量获取好友验证数据
Future<BaseResponse<IGetFriendVerifiesListByIdsRes>>
getFriendVerifiesListByIdsApi(IGetFriendVerifiesListByIdsReq data) {
  const url = '/api/friend/getFriendVerifiesListByIds';
  return httpClient.post<IGetFriendVerifiesListByIdsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetFriendVerifiesListByIdsRes.fromJson(json),
  );
}

/// 搜索用户 (对标 Desktop getSearchFriendApi)
Future<BaseResponse<IResSearchUserInfo>> getSearchFriendApi(
  ISearchUserReq data,
) {
  const url = '/api/friend/search';
  return httpClient.get<IResSearchUserInfo>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IResSearchUserInfo.fromJson(json),
  );
}

/// 申请添加好友 (对标 Desktop applyAddFriendApi)
Future<BaseResponse<void>> applyAddFriendApi(IAddFriendReq data) {
  const url = '/api/friend/add_friend';
  return httpClient.post<void>(url, data: data.toJson());
}

/// 验证好友申请 (对标 Desktop valiFrienddAPi)
Future<BaseResponse<void>> valiFriendApi(IValiFriendReq data) {
  const url = '/api/friend/valid';
  return httpClient.post<void>(url, data: data.toJson());
}
