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

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/types/call.dart';
import 'event.dart';
import 'state.dart';

import 'package:beaver/store/user/user.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('call-page');

class CallPageBloc extends Bloc<CallPageEvent, CallPageState> {
  final CallStore _callStore;
  final CallBusiness _callBusiness;
  final UserStore _userStore;
  StreamSubscription? _storeSubscription;

  CallPageBloc({
    CallStore? callStore,
    CallBusiness? callBusiness,
    UserStore? userStore,
  }) : _callStore = callStore ?? getIt<CallStore>(),
       _callBusiness = callBusiness ?? getIt<CallBusiness>(),
       _userStore = userStore ?? getIt<UserStore>(),
       super(const CallPageState()) {
    on<InitializeCallEvent>(_onInitialize);
    on<StartCallEvent>(_onStartCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);
    on<EndCallEvent>(_onEndCall);
    on<_UpdateFromStoreEvent>(_onUpdateFromStore);
    on<InviteParticipantsEvent>(_onInviteParticipants);

    // 监听全局 Store 的变化
    _storeSubscription = _callStore.stream.listen((storeState) {
      add(_UpdateFromStoreEvent(storeState));
    });
    
    // 初始化当前状态
    add(_UpdateFromStoreEvent(_callStore.state));
  }

  @override
  Future<void> close() {
    _storeSubscription?.cancel();
    return super.close();
  }

  Future<void> _onInitialize(InitializeCallEvent event, Emitter<CallPageState> emit) async {
    _logger.info({
      'text': '初始化通话页面',
      'data': {
        'conversationId': event.conversationId,
        'callType': event.callType,
        'isGroup': event.isGroup,
      },
    });
    emit(state.copyWith(status: CallStatus.loading, callType: event.callType, isGroup: event.isGroup));
    try {
      await _callBusiness.initialize(event.conversationId, event.roomToken, event.liveKitUrl);
      _logger.info({
        'text': '通话初始化成功，已连接',
        'data': {'conversationId': event.conversationId},
      });
      emit(state.copyWith(status: CallStatus.connected));
    } catch (e) {
      _logger.error({
        'text': '通话初始化失败',
        'data': {
          'conversationId': event.conversationId,
          'error': e.toString(),
        },
      });
      emit(state.copyWith(status: CallStatus.error));
    }
  }

  Future<void> _onStartCall(StartCallEvent event, Emitter<CallPageState> emit) async {
    _logger.info({'text': '发起通话', 'data': {}});
    await _callBusiness.startCall();
  }

  Future<void> _onToggleMute(ToggleMuteEvent event, Emitter<CallPageState> emit) async {
    _logger.info({'text': '切换静音状态', 'data': {'isMuted': !state.isMuted}});
    await _callBusiness.toggleMute();
    emit(state.copyWith(isMuted: !state.isMuted));
  }

  Future<void> _onToggleCamera(ToggleCameraEvent event, Emitter<CallPageState> emit) async {
    _logger.info({'text': '切换摄像头状态', 'data': {'isCameraOff': !state.isCameraOff}});
    await _callBusiness.toggleCamera();
    emit(state.copyWith(isCameraOff: !state.isCameraOff));
  }

  Future<void> _onToggleSpeaker(ToggleSpeakerEvent event, Emitter<CallPageState> emit) async {
    _logger.info({'text': '切换扬声器状态', 'data': {'isSpeakerOn': !state.isSpeakerOn}});
    await _callBusiness.toggleSpeaker();
    emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<CallPageState> emit) async {
    _logger.info({'text': '结束通话', 'data': {}});
    await _callBusiness.endCall();
    emit(state.copyWith(status: CallStatus.ended));
  }

  Future<void> _onInviteParticipants(InviteParticipantsEvent event, Emitter<CallPageState> emit) async {
    _logger.info({
      'text': '邀请成员加入通话',
      'data': {'userIds': event.userIds, 'count': event.userIds.length},
    });
    await _callBusiness.inviteParticipants(event.userIds);
  }
  
  void _onUpdateFromStore(_UpdateFromStoreEvent event, Emitter<CallPageState> emit) {
    emit(state.copyWith(participants: event.storeState.members));
  }

  CallParticipant? get localParticipant {
      final members = _callStore.state.members;
      if (members.isEmpty) return null;
      final currentUserId = _userStore.state.currentUserId;
      return members.firstWhere((p) => p.userId == currentUserId, orElse: () => members[0]);
  }
}

class _UpdateFromStoreEvent extends CallPageEvent {
  final CallStoreState storeState;
  const _UpdateFromStoreEvent(this.storeState);
}
