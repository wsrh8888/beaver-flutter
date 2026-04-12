import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/common/config/env.dart';

/// 同步聊天消息
Future<BaseResponse<IChatSyncRes>> chatSyncApi(IChatSyncReq data) {
  final url = '$baseUrl/api/chat/sync';
  return httpClient.post<IChatSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IChatSyncRes.fromJson(json));
}

/// 批量获取会话数据
Future<BaseResponse<IGetConversationsListByIdsRes>> getConversationsListByIdsApi(IGetConversationsListByIdsReq data) {
  final url = '$baseUrl/api/chat/getConversationsListByIds';
  return httpClient.post<IGetConversationsListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetConversationsListByIdsRes.fromJson(json));
}

/// 批量获取用户会话设置数据
Future<BaseResponse<IGetUserConversationSettingsListByIdsRes>> getUserConversationSettingsListByIdsApi(IGetUserConversationSettingsListByIdsReq data) {
  final url = '$baseUrl/api/chat/getUserConversationSettingsListByIds';
  return httpClient.post<IGetUserConversationSettingsListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetUserConversationSettingsListByIdsRes.fromJson(json));
}
/// 更新会话已读序列号
Future<BaseResponse<IUpdateReadSeqRes>> updateReadSeqApi(IUpdateReadSeqReq data) {
  final url = '$baseUrl/api/chat/updateReadSeq';
  return httpClient.post<IUpdateReadSeqRes>(url, data: data.toJson(), fromJsonT: (json) => IUpdateReadSeqRes.fromJson(json));
}

/// 置顶/取消置顶会话
Future<BaseResponse<IPinnedChatRes>> pinnedChatApi(IPinnedChatReq data) {
  final url = '$baseUrl/api/chat/pinnedChat';
  return httpClient.post<IPinnedChatRes>(url, data: data.toJson(), fromJsonT: (json) => IPinnedChatRes.fromJson(json));
}

/// 获取合并转发详情
Future<BaseResponse<IGetForwardDetailsRes>> getForwardDetailsApi(IGetForwardDetailsReq data) {
  final url = '$baseUrl/api/chat/getForwardDetails';
  return httpClient.get<IGetForwardDetailsRes>(url, queryParameters: data.toJson(), fromJsonT: (json) => IGetForwardDetailsRes.fromJson(json));
}

/// 转发消息
Future<BaseResponse<IForwardMessageRes>> forwardMessageApi(IForwardMessageReq data) {
  final url = '$baseUrl/api/chat/forward';
  return httpClient.post<IForwardMessageRes>(url, data: data.toJson(), fromJsonT: (json) => IForwardMessageRes.fromJson(json));
}
