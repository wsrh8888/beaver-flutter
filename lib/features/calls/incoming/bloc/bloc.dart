import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/incoming/bloc/event.dart';
import 'package:beaver/features/calls/incoming/bloc/state.dart';
import 'package:beaver/features/calls/incoming/data/repositories/repository.dart';
import 'package:beaver/features/calls/data/models/call.dart';

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
      final callInfo = await _repository.getCallInfo(event.conversationId);
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
      await _repository.acceptCall(state.callInfo!.conversationId);
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
      await _repository.rejectCall(state.callInfo!.conversationId);
      emit(state.copyWith(status: CallStatus.ended));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '拒绝通话失败: $e',
      ));
    }
  }
}
