import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/oauth.dart';

/// 查询扫码会话（公开）
Future<BaseResponse<IGetQrCodeSceneRes>> getQrCodeSceneApi(String sceneId) {
  final url = '$baseUrl/api/open/oauth_public/v1/qrcode_scene';
  return httpClient.get<IGetQrCodeSceneRes>(
    url,
    queryParameters: {'sceneId': sceneId},
    fromJsonT: (json) => IGetQrCodeSceneRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 标记已扫码（需 IM 登录态）
Future<BaseResponse<IScanQrCodeRes>> scanQrCodeApi(IScanQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_scan';
  return httpClient.post<IScanQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IScanQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 确认扫码授权（需 IM 登录态）
Future<BaseResponse<IConfirmQrCodeRes>> confirmQrCodeApi(IConfirmQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_confirm';
  return httpClient.post<IConfirmQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IConfirmQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}

/// 取消扫码授权（需 IM 登录态）
Future<BaseResponse<ICancelQrCodeRes>> cancelQrCodeApi(ICancelQrCodeReq data) {
  final url = '$baseUrl/api/open/oauth/v1/qrcode_cancel';
  return httpClient.post<ICancelQrCodeRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICancelQrCodeRes.fromJson(json as Map<String, dynamic>),
  );
}
