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

/// 解散群组（仅群主）
Future<BaseResponse> deleteGroupApi(IGroupDeleteReq data) {
  final url = '$baseUrl/api/group/v1/delete';
  return httpClient.post(url, data: data.toJson());
}

/// 退出群组
Future<BaseResponse> quitGroupApi(IGroupQuitReq data) {
  final url = '$baseUrl/api/group/v1/quit';
  return httpClient.post(url, data: data.toJson());
}

/// 获取群信息
Future<BaseResponse<IGroupInfoRes>> getGroupInfoApi(IGroupInfoReq data) {
  final url = '$baseUrl/api/group/v1/info';
  return httpClient.post<IGroupInfoRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGroupInfoRes.fromJson(json),
  );
}

/// 申请加入群组
Future<BaseResponse<IGroupJoinRes>> joinGroupApi(IGroupJoinReq data) {
  final url = '$baseUrl/api/group/v1/join';
  return httpClient.post<IGroupJoinRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGroupJoinRes.fromJson(json),
  );
}

/// 解析群邀请短码
Future<BaseResponse<IResolveGroupInviteRes>> resolveGroupInviteApi(
  IResolveGroupInviteReq data,
) {
  final url = '$baseUrl/api/group/v1/invite_code';
  return httpClient.get<IResolveGroupInviteRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IResolveGroupInviteRes.fromJson(json),
  );
}

