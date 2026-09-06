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

import 'package:beaver/types/call.dart';
import 'package:beaver/api/call.dart';
import 'package:beaver/types/api/call.dart' as api;
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-calls-incoming');

class CallIncomingRepository {
  Future<CallInfo> getCallInfo(String conversationId, String roomId) async {
    try {

    final response = await getCallInfoApi(roomId);
    if (response.code == 0 && response.result != null) {
      final res = response.result!;
      return CallInfo(
        conversationId: conversationId, // 补充会话ID
        callerName: res.callerName,
        callerAvatar: res.callerAvatar,
        isIncoming: res.isIncoming,
        callType: res.callType == 'video' ? CallType.video : CallType.audio,
        roomId: res.roomId.isNotEmpty ? res.roomId : roomId,
        roomToken: res.roomToken,
        liveKitUrl: res.liveKitUrl,
      );
    }
    throw Exception(response.msg);
    } catch (e, st) {
      _logger.warn({'text':'CallIncomingRepository.getCallInfo 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
  
  Future<void> acceptCall(String roomId) async {
    try {

    final response = await acceptCallApi(api.AcceptCallReq(roomId: roomId));
    if (response.code != 0) {
      throw Exception(response.msg);
    }
    } catch (e, st) {
      _logger.warn({'text':'CallIncomingRepository.acceptCall 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
  
  Future<void> rejectCall(String roomId) async {
    try {

    final response = await rejectCallApi(api.RejectCallReq(roomId: roomId));
    if (response.code != 0) {
      throw Exception(response.msg);
    }
    } catch (e, st) {
      _logger.warn({'text':'CallIncomingRepository.rejectCall 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
