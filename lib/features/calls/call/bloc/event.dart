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

import 'package:equatable/equatable.dart';
import 'package:beaver/types/call.dart';

abstract class CallPageEvent extends Equatable {
  const CallPageEvent();
  
  @override
  List<Object?> get props => [];
}

class InitializeCallEvent extends CallPageEvent {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;
  final CallType callType;
  final bool isGroup;
  
  const InitializeCallEvent(this.conversationId, this.roomToken, this.liveKitUrl, this.callType, {this.isGroup = false});
  
  @override
  List<Object?> get props => [conversationId, roomToken, liveKitUrl, callType, isGroup];
}

class StartCallEvent extends CallPageEvent {
  const StartCallEvent();
}

class EndCallEvent extends CallPageEvent {
  const EndCallEvent();
}

class ToggleMuteEvent extends CallPageEvent {
  const ToggleMuteEvent();
}

class ToggleCameraEvent extends CallPageEvent {
  const ToggleCameraEvent();
}

class ToggleSpeakerEvent extends CallPageEvent {
  const ToggleSpeakerEvent();
}

class InviteParticipantsEvent extends CallPageEvent {
  final List<String> userIds;
  const InviteParticipantsEvent(this.userIds);
  
  @override
  List<Object?> get props => [userIds];
}
