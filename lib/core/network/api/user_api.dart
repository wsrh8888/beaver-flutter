import '../request/request.dart';
import 'api_client.dart';

/// 用户相关接口 (对标 desktop render/api/user.ts、main/api/user.ts)
class UserApi {
  const UserApi(this._client);
  final ApiClient _client;

  /// 用户数据同步
  Future<BaseResponse<T>> sync<T>(Map<String, dynamic> data, T Function(dynamic) fromJsonT) {
    return _client.post<T>('/api/user/sync', data: data, fromJsonT: fromJsonT);
  }
}
