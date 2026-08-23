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

class CallPageState extends Equatable {
  final CallStatus status;
  final List<CallParticipant> participants;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final String? errorMessage;
  final CallType callType;
  final bool isGroup;
  final bool isLocalVideoSmall;
  
  const CallPageState({
    this.status = CallStatus.initial,
    this.participants = const [],
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = true,
    this.errorMessage,
    this.callType = CallType.audio,
    this.isGroup = false,
    this.isLocalVideoSmall = true,
  });
  
  @override
  List<Object?> get props => [
    status,
    participants,
    isMuted,
    isCameraOff,
    isSpeakerOn,
    errorMessage,
    callType,
    isGroup,
    isLocalVideoSmall,
  ];
  
  CallPageState copyWith({
    CallStatus? status,
    List<CallParticipant>? participants,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    String? errorMessage,
    CallType? callType,
    bool? isGroup,
    bool? isLocalVideoSmall,
  }) {
    return CallPageState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      errorMessage: errorMessage ?? this.errorMessage,
      callType: callType ?? this.callType,
      isGroup: isGroup ?? this.isGroup,
      isLocalVideoSmall: isLocalVideoSmall ?? this.isLocalVideoSmall,
    );
  }
}
