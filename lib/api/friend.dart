import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/common/config/env.dart';

/// 批量获取好友数据
Future<BaseResponse<IGetFriendsListByIdsRes>> getFriendsListByIdsApi(
  IGetFriendsListByIdsReq data,
) {
  final url = '$baseUrl/api/friend/v1/getFriendsListByIds';
  return httpClient.post<IGetFriendsListByIdsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetFriendsListByIdsRes.fromJson(json),
  );
}

/// 批量获取好友验证数据
Future<BaseResponse<IGetFriendVerifiesListByIdsRes>>
getFriendVerifiesListByIdsApi(IGetFriendVerifiesListByIdsReq data) {
  final url = '$baseUrl/api/friend/v1/getFriendVerifiesListByIds';
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
  final url = '$baseUrl/api/friend/v1/search';
  return httpClient.get<IResSearchUserInfo>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IResSearchUserInfo.fromJson(json),
  );
}

/// 申请添加好友 (对标 Desktop applyAddFriendApi)
Future<BaseResponse<void>> applyAddFriendApi(IAddFriendReq data) {
  final url = '$baseUrl/api/friend/v1/add_friend';
  return httpClient.post<void>(url, data: data.toJson());
}

/// 验证好友申请 (对标 Desktop valiFrienddAPi)
Future<BaseResponse<void>> valiFriendApi(IValiFriendReq data) {
  final url = '$baseUrl/api/friend/v1/valid';
  return httpClient.post<void>(url, data: data.toJson());
}

/// 修改好友备注 (对标 Desktop updateRemarkNameApi)
Future<BaseResponse<INoticeUpdateRes>> updateRemarkNameApi(
  INoticeUpdateReq data,
) {
  final url = '$baseUrl/api/friend/v1/update_notice';
  return httpClient.post<INoticeUpdateRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => INoticeUpdateRes.fromJson(json),
  );
}

