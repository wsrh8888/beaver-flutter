import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/common/config/env.dart';

/// 上报版本信息
Future<BaseResponse<void>> reportVersionApi(ReportVersionReq data) async {
  return httpClient.post<void>(
    '$baseUrl/api/update/report',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => null,
  );
}

/// 获取最新版本
Future<BaseResponse<GetLatestVersionRes>> getLatestVersionApi(GetLatestVersionReq data) async {
  return httpClient.post<GetLatestVersionRes>(
    '$baseUrl/api/update/latest',
    data: data.toJson(),
    headers: data.toHeaders(),
    fromJsonT: (json) => GetLatestVersionRes.fromJson(json),
  );
}
