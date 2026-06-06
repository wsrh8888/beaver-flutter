import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/common/config/env.dart';

/// 群组数据同步
Future<BaseResponse<IGroupSyncRes>> groupSyncApi(IGroupSyncReq data) {
  final url = '$baseUrl/api/group/v1/sync';
  return httpClient.post<IGroupSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupSyncRes.fromJson(json));
}

/// 群成员数据同步
Future<BaseResponse<IGroupMemberSyncRes>> groupMemberSyncApi(IGroupMemberSyncReq data) {
  final url = '$baseUrl/api/group/v1/member_sync';
  return httpClient.post<IGroupMemberSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupMemberSyncRes.fromJson(json));
}

/// 入群申请数据同步
Future<BaseResponse<IGroupJoinRequestSyncRes>> groupJoinRequestSyncApi(IGroupJoinRequestSyncReq data) {
  final url = '$baseUrl/api/group/v1/join_request_sync';
  return httpClient.post<IGroupJoinRequestSyncRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupJoinRequestSyncRes.fromJson(json));
}

/// 创建群组
Future<BaseResponse<IGroupCreateRes>> createGroupApi(IGroupCreateReq data) {
  final url = '$baseUrl/api/group/v1/create';
  return httpClient.post<IGroupCreateRes>(url, data: data.toJson(), fromJsonT: (json) => IGroupCreateRes.fromJson(json));
}

/// 添加群成员
Future<BaseResponse> addGroupMemberApi(IGroupAddMembersReq data) {
  final url = '$baseUrl/api/group/v1/member_add';
  return httpClient.post(url, data: data.toJson());
}

/// 移除群成员
Future<BaseResponse> removeGroupMemberApi(IGroupRemoveMembersReq data) {
  final url = '$baseUrl/api/group/v1/member_remove';
  return httpClient.post(url, data: data.toJson());
}

