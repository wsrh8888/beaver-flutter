import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/calls_page/bloc/event.dart';
import 'package:beaver/features/calls/calls_page/bloc/state.dart';
import 'package:beaver/features/calls/calls_page/data/repositories/repository.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository _repository;

  CallBloc(this._repository) : super(const CallState()) {
    on<LoadCallInfoEvent>(_onLoadCallInfo);
    on<StartCallEvent>(_onStartCall);
    on<EndCallEvent>(_onEndCall);
  }

  Future<void> _onLoadCallInfo(
    LoadCallInfoEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));

    try {
      final callInfo = await _repository.getCallInfo(event.conversationId);
      emit(state.copyWith(
        status: CallStatus.initial,
        callInfo: callInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '加载通话信息失败: $e',
      ));
    }
  }

  Future<void> _onStartCall(
    StartCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));

    try {
      await _repository.startCall(event.conversationId);
      emit(state.copyWith(status: CallStatus.connected));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '开始通话失败: $e',
      ));
    }
  }

  Future<void> _onEndCall(
    EndCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));

    try {
      await _repository.endCall(state.callInfo?.conversationId ?? '');
      emit(state.copyWith(status: CallStatus.ended));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '结束通话失败: $e',
      ));
    }
  }
}
