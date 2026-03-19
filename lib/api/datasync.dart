import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/datasync.dart';

/// 获取所有需要更新的用户版本信息
Future<BaseResponse<IGetSyncAllUsersRes>> datasyncGetSyncAllUsersApi(IGetSyncAllUsersReq data) {
  const url = '/api/datasync/getSyncAllUsers';
  return httpClient.post<IGetSyncAllUsersRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncAllUsersRes.fromJson(json));
}

/// 获取所有需要更新的群组信息版本
Future<BaseResponse<IGetSyncGroupInfoRes>> datasyncGetSyncGroupInfoApi(IGetSyncGroupInfoReq data) {
  const url = '/api/datasync/getSyncGroupInfo';
  return httpClient.post<IGetSyncGroupInfoRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupInfoRes.fromJson(json));
}

/// 获取所有需要更新的聊天消息版本
Future<BaseResponse<IGetSyncChatMessagesRes>> datasyncGetSyncChatMessagesApi(IGetSyncChatMessagesReq data) {
  const url = '/api/datasync/getSyncChatMessages';
  return httpClient.post<IGetSyncChatMessagesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatMessagesRes.fromJson(json));
}

/// 获取所有需要更新的好友版本
Future<BaseResponse<IGetSyncFriendsRes>> datasyncGetSyncFriendsApi(IGetSyncFriendsReq data) {
  const url = '/api/datasync/getSyncFriends';
  return httpClient.post<IGetSyncFriendsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncFriendsRes.fromJson(json));
}

/// 获取所有需要更新的好友验证版本
Future<BaseResponse<IGetSyncFriendVerifiesRes>> datasyncGetSyncFriendVerifiesApi(IGetSyncFriendVerifiesReq data) {
  const url = '/api/datasync/getSyncFriendVerifies';
  return httpClient.post<IGetSyncFriendVerifiesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncFriendVerifiesRes.fromJson(json));
}

/// 获取已同步的表情列表
Future<BaseResponse<IGetSyncEmojisRes>> datasyncGetSyncEmojisApi(IGetSyncEmojisReq data) {
  const url = '/api/datasync/getSyncEmojis';
  return httpClient.post<IGetSyncEmojisRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncEmojisRes.fromJson(json));
}

/// 获取已同步的通知事件列表
Future<BaseResponse<IGetSyncNotificationEventsRes>> datasyncGetSyncNotificationEventsApi(IGetSyncNotificationEventsReq data) {
  const url = '/api/datasync/getSyncNotificationEvents';
  return httpClient.post<IGetSyncNotificationEventsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationEventsRes.fromJson(json));
}

/// 获取所有需要更新的会话版本
Future<BaseResponse<IGetSyncChatConversationsRes>> datasyncGetSyncChatConversationsApi(IGetSyncChatConversationsReq data) {
  const url = '/api/datasync/getSyncChatConversations';
  return httpClient.post<IGetSyncChatConversationsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatConversationsRes.fromJson(json));
}

/// 获取所有需要更新的用户会话设置版本
Future<BaseResponse<IGetSyncChatUserConversationsRes>> datasyncGetSyncChatUserConversationsApi(IGetSyncChatUserConversationsReq data) {
  const url = '/api/datasync/getSyncChatUserConversations';
  return httpClient.post<IGetSyncChatUserConversationsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncChatUserConversationsRes.fromJson(json));
}

/// 获取所有需要更新的群成员版本
Future<BaseResponse<IGetSyncGroupMembersRes>> datasyncGetSyncGroupMembersApi(IGetSyncGroupMembersReq data) {
  const url = '/api/datasync/getSyncGroupMembers';
  return httpClient.post<IGetSyncGroupMembersRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupMembersRes.fromJson(json));
}

/// 获取所有需要更新的入群申请版本
Future<BaseResponse<IGetSyncGroupRequestsRes>> datasyncGetSyncGroupRequestsApi(IGetSyncGroupRequestsReq data) {
  const url = '/api/datasync/getSyncGroupRequests';
  return httpClient.post<IGetSyncGroupRequestsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncGroupRequestsRes.fromJson(json));
}

/// 获取所有需要更新的表情收藏版本
Future<BaseResponse<IGetSyncEmojiCollectsRes>> datasyncGetSyncEmojiCollectsApi(IGetSyncEmojiCollectsReq data) {
  const url = '/api/datasync/getSyncEmojiCollects';
  return httpClient.post<IGetSyncEmojiCollectsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncEmojiCollectsRes.fromJson(json));
}

/// 获取通知收件箱版本摘要
Future<BaseResponse<IGetSyncNotificationInboxesRes>> datasyncGetSyncNotificationInboxesApi(IGetSyncNotificationInboxesReq data) {
  const url = '/api/datasync/getSyncNotificationInboxes';
  return httpClient.post<IGetSyncNotificationInboxesRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationInboxesRes.fromJson(json));
}

/// 获取通知已读游标版本摘要
Future<BaseResponse<IGetSyncNotificationReadCursorsRes>> datasyncGetSyncNotificationReadCursorsApi(IGetSyncNotificationReadCursorsReq data) {
  const url = '/api/datasync/getSyncNotificationReadCursors';
  return httpClient.post<IGetSyncNotificationReadCursorsRes>(url, data: data.toJson(), fromJsonT: (json) => IGetSyncNotificationReadCursorsRes.fromJson(json));
}
