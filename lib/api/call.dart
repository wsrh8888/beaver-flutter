import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/call.dart';
import 'package:beaver/common/config/env.dart';

/// 获取通话信息 (获取Token等)
Future<BaseResponse<CallInfoRes>> getCallInfoApi(String roomId) {
  final url = '$baseUrl/api/call/v1/token';
  return httpClient.post<CallInfoRes>(url, 
    data: {'roomId': roomId},
    fromJsonT: (json) => CallInfoRes.fromJson(json),
  );
}

/// 接受通话
Future<BaseResponse<bool>> acceptCallApi(AcceptCallReq data) {
  final url = '$baseUrl/api/call/v1/token'; 
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => true);
}

/// 拒绝通话
Future<BaseResponse<bool>> rejectCallApi(RejectCallReq data) {
  final url = '$baseUrl/api/call/v1/hangup';
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => true);
}

/// 邀请参与者
Future<BaseResponse<bool>> inviteParticipantsApi(InviteParticipantsReq data) {
  final url = '$baseUrl/api/call/v1/invite';
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => true);
}

/// 开始通话
Future<BaseResponse<CallInfoRes>> startCallApi(StartCallReq data) {
  final url = '$baseUrl/api/call/v1/start';
  return httpClient.post<CallInfoRes>(url, data: data.toJson(), fromJsonT: (json) => CallInfoRes.fromJson(json));
}

/// 结束通话
Future<BaseResponse<bool>> endCallApi(EndCallReq data) {
  final url = '$baseUrl/api/call/v1/hangup'; // 用hangup代替
  return httpClient.post<bool>(url, data: data.toJson(), fromJsonT: (json) => true);
}

/// 获取通话历史
Future<BaseResponse<List<CallHistoryRes>>> getCallHistoryApi() {
  final url = '$baseUrl/api/call/v1/history';
  return httpClient.get<List<CallHistoryRes>>(url, 
    fromJsonT: (json) => (json as List).map((item) => CallHistoryRes.fromJson(item)).toList(),
  );
}

/// 删除通话历史
Future<BaseResponse<bool>> deleteCallHistoryApi(String callId) {
  final url = '$baseUrl/api/call/v1/history/$callId';
  return httpClient.post<bool>(url, fromJsonT: (json) => true);
}

/// 清空通话历史
Future<BaseResponse<bool>> clearCallHistoryApi() {
  final url = '$baseUrl/api/call/v1/history';
  return httpClient.post<bool>(url, fromJsonT: (json) => true);
}

