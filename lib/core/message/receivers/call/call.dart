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

import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/call/call_list.dart';
import 'package:beaver/store/contact/contact.dart';

/// 通话 WS 信令接收器（对标 Desktop CallMessageRouter）
// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('call-message-receiver');

class CallMessageReceiver {
  final _openedIncomingRooms = <String>{};

  void processCallMessage(Map<String, dynamic> content) {
    final data = content['data'];
    if (data is! Map<String, dynamic>) return;

    final payload = _resolvePayload(data);
    if (payload == null) return;

    _logger.info({'text': '收到通话信令', 'data': {'payload': payload}});

    switch (payload['type'] as String?) {
      case 'RTC_INVITE':
        _handleInvite(payload);
        break;
      case 'RTC_ACCEPTED':
        _handleAccepted(payload);
        break;
      case 'RTC_HANGUP':
      case 'RTC_CANCEL':
        _handleHangup(payload);
        break;
      case 'RTC_REJECT':
        _handleRejected(payload);
        break;
    }
  }

  Map<String, dynamic>? _resolvePayload(Map<String, dynamic> data) {
    if (data['type'] == 'call_receive') {
      final body = data['body'];
      final conversationId = data['conversationId'] as String? ?? '';

      if (body is Map<String, dynamic>) {
        return {...body, 'conversationId': conversationId};
      }
      return null;
    }
    return data;
  }

  void _handleInvite(Map<String, dynamic> payload) {
    final callerId = payload['callerId'] as String?;
    if (callerId == null || callerId.isEmpty) return;

    final roomId = payload['roomId'] as String? ?? '';
    if (roomId.isEmpty) return;

    final conversationId = payload['conversationId'] as String? ?? '';
    final callTypeRaw = payload['callType'];
    final callType = callTypeRaw == 2 ? 'group' : 'private';
    final timestamp = _readTimestamp(payload['timestamp']);

    String? callerName;
    String? callerAvatar;
    final callerUserInfo = payload['callerUserInfo'];
    if (callerUserInfo is Map) {
      callerName = callerUserInfo['nickName'] as String?;
      callerAvatar = callerUserInfo['avatar'] as String?;
    }

    final callListStore = getIt<CallListStore>();
    callListStore.addIncomingCall(
      roomId: roomId,
      callType: callType,
      callerId: callerId,
      conversationId: conversationId,
      timestamp: timestamp,
      callerName: callerName,
      callerAvatar: callerAvatar,
    );

    _loadCallerInfo(roomId, callerId);
    _openIncomingPage(conversationId, roomId);
  }

  void _handleAccepted(Map<String, dynamic> payload) {
    final roomId = payload['roomId'] as String? ?? '';
    if (roomId.isEmpty) return;
    getIt<CallListStore>().updateCallStatus(roomId, CallListItemStatus.active);
  }

  void _handleHangup(Map<String, dynamic> payload) {
    final roomId = payload['roomId'] as String? ?? '';
    if (roomId.isEmpty) return;
    getIt<CallListStore>().removeCall(roomId);
    _openedIncomingRooms.remove(roomId);
  }

  void _handleRejected(Map<String, dynamic> payload) {
    _handleHangup(payload);
  }

  Future<void> _loadCallerInfo(String roomId, String callerId) async {
    final contact = getIt<ContactStore>().getContact(callerId);
    if (contact == null) return;

    getIt<CallListStore>().updateCallerInfo(
      roomId,
      name: contact.nickname,
      avatar: contact.avatar,
    );
  }

  void _openIncomingPage(String conversationId, String roomId) {
    if (_openedIncomingRooms.contains(roomId)) return;
    _openedIncomingRooms.add(roomId);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        _openedIncomingRooms.remove(roomId);
        return;
      }

      context
          .push(
            AppRoutes.callIncoming,
            extra: {
              'conversationId': conversationId,
              'roomId': roomId,
            },
          )
          .whenComplete(() => _openedIncomingRooms.remove(roomId));
    });
  }

  int _readTimestamp(dynamic value) {
    if (value is int) {
      return value > 9999999999 ? value : value * 1000;
    }
    return DateTime.now().millisecondsSinceEpoch;
  }
}
