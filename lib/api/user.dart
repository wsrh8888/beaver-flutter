import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/config/env.dart';

/// 用户数据同步
Future<BaseResponse<T>> userSyncApi<T>(Map<String, dynamic> data, T Function(dynamic) fromJsonT) {
  final url = '$baseUrl/api/user/sync';
  return httpClient.post<T>(url, data: data, fromJsonT: fromJsonT);
}

