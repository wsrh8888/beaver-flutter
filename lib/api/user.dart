import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/user.dart';

/// 用户数据同步
Future<BaseResponse<IUserSyncRes>> userSyncApi(IUserSyncReq data) {
  const url = '/api/user/sync';
  return httpClient.post<IUserSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IUserSyncRes.fromJson(json));
}

/// 更新用户信息
Future<BaseResponse<UpdateInfoRes>> updateInfoApi(IUpdateInfoReq data) {
  const url = '/api/user/update_info';
  return httpClient.post<UpdateInfoRes>(url, data: data.toJson(), fromJsonT: (json) => UpdateInfoRes());
}

/// 修改邮箱
Future<BaseResponse<UpdateEmailRes>> updateEmailApi(IUpdateEmailReq data) {
  const url = '/api/user/update_email';
  return httpClient.post<UpdateEmailRes>(url, data: data.toJson(), fromJsonT: (json) => UpdateEmailRes());
}

/// 增加空的 Res 类用于对齐 api 定义
class UpdateInfoRes {}
class UpdateEmailRes {}
