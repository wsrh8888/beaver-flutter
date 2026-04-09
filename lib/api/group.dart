import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/group.dart';

/// 群组数据同步
Future<BaseResponse<IGroupSyncRes>> groupSyncApi(IGroupSyncReq data) {
  const url = '/api/group/sync';
  return httpClient.post<IGroupSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupSyncRes.fromJson(json));
}

/// 群成员数据同步
Future<BaseResponse<IGroupMemberSyncRes>> groupMemberSyncApi(IGroupMemberSyncReq data) {
  const url = '/api/group/member-sync';
  return httpClient.post<IGroupMemberSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupMemberSyncRes.fromJson(json));
}

/// 入群申请数据同步
Future<BaseResponse<IGroupJoinRequestSyncRes>> groupJoinRequestSyncApi(IGroupJoinRequestSyncReq data) {
  const url = '/api/group/join-request-sync';
  return httpClient.post<IGroupJoinRequestSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupJoinRequestSyncRes.fromJson(json));
}

/// 创建群组
Future<BaseResponse<IGroupCreateRes>> createGroupApi(IGroupCreateReq data) {
  const url = '/api/group/create';
  return httpClient.post<IGroupCreateRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupCreateRes.fromJson(json));
}

/// 添加群成员
Future<BaseResponse> addGroupMemberApi(IGroupAddMembersReq data) {
  const url = '/api/group/add-member';
  return httpClient.post(url, data: data.toJson());
}

/// 移除群成员
Future<BaseResponse> removeGroupMemberApi(IGroupRemoveMembersReq data) {
  const url = '/api/group/remove-member';
  return httpClient.post(url, data: data.toJson());
}
