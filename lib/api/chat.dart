import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/chat.dart';

/// 同步聊天消息
Future<BaseResponse<IChatSyncRes>> chatSyncApi(IChatSyncReq data) {
  const url = '/api/chat/sync';
  return httpClient.post<IChatSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IChatSyncRes.fromJson(json));
}

/// 批量获取会话数据
Future<BaseResponse<IGetConversationsListByIdsRes>> getConversationsListByIdsApi(IGetConversationsListByIdsReq data) {
  const url = '/api/chat/getConversationsListByIds';
  return httpClient.post<IGetConversationsListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetConversationsListByIdsRes.fromJson(json));
}

/// 批量获取用户会话设置数据
Future<BaseResponse<IGetUserConversationSettingsListByIdsRes>> getUserConversationSettingsListByIdsApi(IGetUserConversationSettingsListByIdsReq data) {
  const url = '/api/chat/getUserConversationSettingsListByIds';
  return httpClient.post<IGetUserConversationSettingsListByIdsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetUserConversationSettingsListByIdsRes.fromJson(json));
}
/// 更新会话已读序列号
Future<BaseResponse<IUpdateReadSeqRes>> updateReadSeqApi(IUpdateReadSeqReq data) {
  const url = '/api/chat/updateReadSeq';
  return httpClient.post<IUpdateReadSeqRes>(url, data: data.toJson(), fromJsonT: (json) => IUpdateReadSeqRes.fromJson(json));
}

/// 置顶/取消置顶会话
Future<BaseResponse<IPinnedChatRes>> pinnedChatApi(IPinnedChatReq data) {
  const url = '/api/chat/pinnedChat';
  return httpClient.post<IPinnedChatRes>(url, data: data.toJson(), fromJsonT: (json) => IPinnedChatRes.fromJson(json));
}
