import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/call.dart';

/// 获取通话信息
Future<BaseResponse<CallInfoRes>> getCallInfoApi(String conversationId) {
  const url = '/call/info';
  return httpClient.get<CallInfoRes>(url, 
    queryParameters: {'conversationId': conversationId},
    fromJsonT: (json) => CallInfoRes.fromJson(json),
  );
}

/// 接受通话
Future<BaseResponse<bool>> acceptCallApi(AcceptCallReq data) {
  const url = '/call/accept';
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => json as bool);
}

/// 拒绝通话
Future<BaseResponse<bool>> rejectCallApi(RejectCallReq data) {
  const url = '/call/reject';
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => json as bool);
}

/// 开始通话
Future<BaseResponse<CallInfoRes>> startCallApi(StartCallReq data) {
  const url = '/call/start';
  return httpClient.post<CallInfoRes>(url, data: data.toJson(), fromJsonT: (json) => CallInfoRes.fromJson(json));
}

/// 结束通话
Future<BaseResponse<bool>> endCallApi(EndCallReq data) {
  const url = '/call/end';
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => json as bool);
}

/// 获取通话历史
Future<BaseResponse<List<CallHistoryRes>>> getCallHistoryApi() {
  const url = '/call/history';
  return httpClient.get<List<CallHistoryRes>>(url, 
    fromJsonT: (json) => (json as List).map((item) => CallHistoryRes.fromJson(item)).toList(),
  );
}

/// 删除通话历史
Future<BaseResponse<bool>> deleteCallHistoryApi(String callId) {
  final url = '/call/history/$callId';
  return httpClient.post<bool>(url, fromJsonT: (json) => json as bool);
}

/// 清空通话历史
Future<BaseResponse<bool>> clearCallHistoryApi() {
  const url = '/call/history';
  return httpClient.post<bool>(url, fromJsonT: (json) => json as bool);
}

