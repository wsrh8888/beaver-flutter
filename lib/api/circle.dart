import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

/// 获取我的圈子列表
Future<BaseResponse<IGetMyCircleListRes>> getMyCircleListApi(
  IGetMyCircleListReq data,
) {
  final url = '$baseUrl/api/circle/v1/circle/mine';
  return httpClient.get<IGetMyCircleListRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetMyCircleListRes.fromJson(json),
  );
}

/// 创建圈子
Future<BaseResponse<ICreateCircleRes>> createCircleApi(ICreateCircleReq data) {
  final url = '$baseUrl/api/circle/v1/circle/create';
  return httpClient.post<ICreateCircleRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateCircleRes.fromJson(json),
  );
}

/// 加入圈子（邀请或分享链接）
Future<BaseResponse<IJoinCircleRes>> joinCircleApi(IJoinCircleReq data) {
  final url = '$baseUrl/api/circle/v1/circle/join';
  return httpClient.post<IJoinCircleRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IJoinCircleRes.fromJson(json),
  );
}
