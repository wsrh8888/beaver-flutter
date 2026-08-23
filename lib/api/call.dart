/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

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

