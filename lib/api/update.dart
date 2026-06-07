import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/env.dart';

/// 上报版本信息
Future<BaseResponse<void>> reportVersionApi(IReportVersionReq data) async {
  return httpClient.post<void>(
    '$baseUrl/api/platform/update_public/v1/report',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => null,
  );
}

/// 获取最新版本
Future<BaseResponse<IGetLatestVersionRes>> getLatestVersionApi(
  IGetLatestVersionReq data,
) async {
  return httpClient.post<IGetLatestVersionRes>(
    '$baseUrl/api/platform/update_public/v1/latest',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => IGetLatestVersionRes.fromJson(json),
  );
}
