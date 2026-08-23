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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/incoming/bloc/event.dart';
import 'package:beaver/features/calls/incoming/bloc/state.dart';
import 'package:beaver/features/calls/incoming/data/repositories/repository.dart';
import 'package:beaver/types/call.dart';

class CallIncomingBloc extends Bloc<CallIncomingEvent, CallIncomingState> {
  final CallIncomingRepository _repository;
  
  CallIncomingBloc(this._repository) : super(const CallIncomingState()) {
    on<LoadCallInfoEvent>(_onLoadCallInfo);
    on<AcceptCallEvent>(_onAcceptCall);
    on<RejectCallEvent>(_onRejectCall);
  }
  
  Future<void> _onLoadCallInfo(
    LoadCallInfoEvent event,
    Emitter<CallIncomingState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));
    
    try {
      final callInfo = await _repository.getCallInfo(event.conversationId, event.roomId);
      emit(state.copyWith(
        status: CallStatus.ringing,
        callInfo: callInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '加载通话信息失败: $e',
      ));
    }
  }
  
  Future<void> _onAcceptCall(
    AcceptCallEvent event,
    Emitter<CallIncomingState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));
    
    try {
      await _repository.acceptCall(state.callInfo!.roomId);
      emit(state.copyWith(status: CallStatus.connected));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '接受通话失败: $e',
      ));
    }
  }
  
  Future<void> _onRejectCall(
    RejectCallEvent event,
    Emitter<CallIncomingState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));
    
    try {
      await _repository.rejectCall(state.callInfo!.roomId);
      emit(state.copyWith(status: CallStatus.ended));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '拒绝通话失败: $e',
      ));
    }
  }
}
