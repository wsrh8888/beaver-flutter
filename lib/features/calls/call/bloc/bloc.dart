import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/call/bloc/event.dart';
import 'package:beaver/features/calls/call/bloc/state.dart';
import 'package:beaver/features/calls/core/call_manager.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallPageBloc extends Bloc<CallPageEvent, CallPageState> implements CallManagerListener {
  final CallManager _callManager = CallManager();
  
  CallPageBloc() : super(const CallPageState()) {
    _callManager.addListener(this);
    
    on<StartCallEvent>(_onStartCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);
  }
  
  @override
  Future<void> close() {
    _callManager.removeListener(this);
    return super.close();
  }
  
  Future<void> _onStartCall(
    StartCallEvent event,
    Emitter<CallPageState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));
    
    try {
      await _callManager.initialize(event.roomToken, event.liveKitUrl);
      await _callManager.startCall();
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
    Emitter<CallPageState> emit,
  ) async {
    emit(state.copyWith(status: CallStatus.loading));
    
    try {
      await _callManager.endCall();
      emit(state.copyWith(
        status: CallStatus.ended,
        participants: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '结束通话失败: $e',
      ));
    }
  }
  
  Future<void> _onToggleMute(
    ToggleMuteEvent event,
    Emitter<CallPageState> emit,
  ) async {
    try {
      await _callManager.toggleMute();
      emit(state.copyWith(isMuted: !state.isMuted));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '切换静音失败: $e',
      ));
    }
  }
  
  Future<void> _onToggleCamera(
    ToggleCameraEvent event,
    Emitter<CallPageState> emit,
  ) async {
    try {
      await _callManager.toggleCamera();
      emit(state.copyWith(isCameraOff: !state.isCameraOff));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '切换摄像头失败: $e',
      ));
    }
  }
  
  Future<void> _onToggleSpeaker(
    ToggleSpeakerEvent event,
    Emitter<CallPageState> emit,
  ) async {
    try {
      await _callManager.toggleSpeaker();
      emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
    } catch (e) {
      emit(state.copyWith(
        status: CallStatus.error,
        errorMessage: '切换扬声器失败: $e',
      ));
    }
  }
  
  @override
  void onConnected() {
    add(const StartCallEvent('', '', ''));
  }
  
  @override
  void onDisconnected() {
    add(const EndCallEvent());
  }
  
  @override
  void onError(String error) {
    emit(state.copyWith(
      status: CallStatus.error,
      errorMessage: error,
    ));
  }
  
  @override
  void onParticipantJoined(CallParticipant participant) {
    final updatedParticipants = [...state.participants, participant];
    emit(state.copyWith(participants: updatedParticipants));
  }
  
  @override
  void onParticipantLeft(CallParticipant participant) {
    final updatedParticipants = state.participants.where((p) => p.userId != participant.userId).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }
  
  @override
  void onParticipantUpdated(CallParticipant participant) {
    final updatedParticipants = state.participants.map((p) {
      if (p.userId == participant.userId) {
        return participant;
      }
      return p;
    }).toList();
    emit(state.copyWith(participants: updatedParticipants));
  }
}
