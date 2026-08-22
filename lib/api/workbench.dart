import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/workbench.dart';

/// 获取工作台应用列表
Future<BaseResponse<IListWorkbenchAppsRes>> listWorkbenchAppsApi([
  IListWorkbenchAppsReq? data,
]) {
  final url = '$baseUrl/api/platform/v1/list_workbench';
  return httpClient.get<IListWorkbenchAppsRes>(
    url,
    queryParameters: data?.toJson(),
    fromJsonT: (json) => IListWorkbenchAppsRes.fromJson(json),
  );
}
