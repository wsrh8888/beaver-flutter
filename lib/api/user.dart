import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/user.dart';

/// 用户数据同步
Future<BaseResponse<IUserSyncRes>> userSyncApi(IUserSyncReq data) {
  const url = '/api/user/sync';
  return httpClient.post<IUserSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IUserSyncRes.fromJson(json));
}
