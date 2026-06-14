import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/common/config/env.dart';

/// 获取所有需要更新的用户版本信息
Future<BaseResponse<IGetSyncAllUsersRes>> datasyncGetSyncAllUsersApi(IGetSyncAllUsersReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncAllUsers';
  return httpClient.post<IGetSyncAllUsersRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncAllUsersRes.fromJson(json));
}

/// 获取所有需要更新的群组信息版本
Future<BaseResponse<IGetSyncGroupInfoRes>> datasyncGetSyncGroupInfoApi(IGetSyncGroupInfoReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncGroupInfo';
  return httpClient.post<IGetSyncGroupInfoRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupInfoRes.fromJson(json));
}

/// 获取所有需要更新的聊天消息版本
Future<BaseResponse<IGetSyncChatMessagesRes>> datasyncGetSyncChatMessagesApi(IGetSyncChatMessagesReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncChatMessages';
  return httpClient.post<IGetSyncChatMessagesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatMessagesRes.fromJson(json));
}

/// 获取所有需要更新的好友版本
Future<BaseResponse<IGetSyncFriendsRes>> datasyncGetSyncFriendsApi(IGetSyncFriendsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncFriends';
  return httpClient.post<IGetSyncFriendsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncFriendsRes.fromJson(json));
}

/// 获取所有需要更新的好友验证版本
Future<BaseResponse<IGetSyncFriendVerifiesRes>> datasyncGetSyncFriendVerifiesApi(IGetSyncFriendVerifiesReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncFriendVerifies';
  return httpClient.post<IGetSyncFriendVerifiesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncFriendVerifiesRes.fromJson(json));
}

/// 获取已同步的表情列表
Future<BaseResponse<IGetSyncEmojisRes>> datasyncGetSyncEmojisApi(IGetSyncEmojisReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncEmojis';
  return httpClient.post<IGetSyncEmojisRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncEmojisRes.fromJson(json));
}

/// 获取已同步的通知事件列表
Future<BaseResponse<IGetSyncNotificationEventsRes>> datasyncGetSyncNotificationEventsApi(IGetSyncNotificationEventsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncNotificationEvents';
  return httpClient.post<IGetSyncNotificationEventsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationEventsRes.fromJson(json));
}

/// 获取所有需要更新的会话版本
Future<BaseResponse<IGetSyncChatConversationsRes>> datasyncGetSyncChatConversationsApi(IGetSyncChatConversationsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncChatConversations';
  return httpClient.post<IGetSyncChatConversationsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatConversationsRes.fromJson(json));
}

/// 获取所有需要更新的用户会话设置版本
Future<BaseResponse<IGetSyncChatUserConversationsRes>> datasyncGetSyncChatUserConversationsApi(IGetSyncChatUserConversationsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncChatUserConversations';
  return httpClient.post<IGetSyncChatUserConversationsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatUserConversationsRes.fromJson(json));
}

/// 获取所有需要更新的群成员版本
Future<BaseResponse<IGetSyncGroupMembersRes>> datasyncGetSyncGroupMembersApi(IGetSyncGroupMembersReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncGroupMembers';
  return httpClient.post<IGetSyncGroupMembersRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupMembersRes.fromJson(json));
}

/// 获取所有需要更新的入群申请版本
Future<BaseResponse<IGetSyncGroupRequestsRes>> datasyncGetSyncGroupRequestsApi(IGetSyncGroupRequestsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncGroupRequests';
  return httpClient.post<IGetSyncGroupRequestsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupRequestsRes.fromJson(json));
}

/// 获取所有需要更新的表情收藏版本
Future<BaseResponse<IGetSyncEmojiCollectsRes>> datasyncGetSyncEmojiCollectsApi(IGetSyncEmojiCollectsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncEmojiCollects';
  return httpClient.post<IGetSyncEmojiCollectsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncEmojiCollectsRes.fromJson(json));
}

/// 获取通知收件箱版本摘要
Future<BaseResponse<IGetSyncNotificationInboxesRes>> datasyncGetSyncNotificationInboxesApi(IGetSyncNotificationInboxesReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncNotificationInboxes';
  return httpClient.post<IGetSyncNotificationInboxesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationInboxesRes.fromJson(json));
}

/// 获取通知已读游标版本摘要
Future<BaseResponse<IGetSyncNotificationReadCursorsRes>> datasyncGetSyncNotificationReadCursorsApi(IGetSyncNotificationReadCursorsReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncNotificationReadCursors';
  return httpClient.post<IGetSyncNotificationReadCursorsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationReadCursorsRes.fromJson(json));
}

/// 同步消息媒体状态（语音已听等）
Future<BaseResponse<IGetSyncMessageMediasRes>> datasyncGetSyncMessageMediasApi(IGetSyncMessageMediasReq data) {
  final url = '$baseUrl/api/datasync/v1/getSyncMessageMedias';
  return httpClient.post<IGetSyncMessageMediasRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetSyncMessageMediasRes.fromJson(json),
  );
}
