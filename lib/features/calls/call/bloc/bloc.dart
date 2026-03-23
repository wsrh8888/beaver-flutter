import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/call/bloc/event.dart';
import 'package:beaver/features/calls/call/bloc/state.dart';
import 'package:beaver/features/calls/core/call_manager.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallPageBloc extends Bloc<CallPageEvent, CallPageState> {
  final CallManager _callManager = CallManager();
  
  CallPageBloc() : super(const CallPageState()) {
    _callManager.addListener(_CallManagerListener(this));
    
    on<StartCallEvent>(_onStartCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);
    on<_UpdateCallStatusEvent>(_onUpdateCallStatus);
    on<_UpdateParticipantsEvent>(_onUpdateParticipants);
  }
  
  @override
  Future<void> close() {
    _callManager.removeListener(_CallManagerListener(this));
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
  
  void _onUpdateCallStatus(_UpdateCallStatusEvent event, Emitter<CallPageState> emit) {
    emit(state.copyWith(
      status: event.status,
      errorMessage: event.errorMessage,
    ));
  }
  
  void _onUpdateParticipants(_UpdateParticipantsEvent event, Emitter<CallPageState> emit) {
    emit(state.copyWith(participants: event.participants));
  }
  
}

class _CallManagerListener implements CallManagerListener {
  final CallPageBloc _bloc;
  
  _CallManagerListener(this._bloc);
  
  @override
  void onConnected() {
    _bloc.add(const StartCallEvent('', '', ''));
  }
  
  @override
  void onDisconnected() {
    _bloc.add(const EndCallEvent());
  }
  
  @override
  void onError(String error) {
    _bloc.add(_UpdateCallStatusEvent(CallStatus.error, errorMessage: error));
  }
  
  @override
  void onParticipantJoined(CallParticipant participant) {
    _bloc.add(_UpdateParticipantsEvent([..._bloc.state.participants, participant]));
  }
  
  @override
  void onParticipantLeft(CallParticipant participant) {
    final updatedParticipants = _bloc.state.participants.where((p) => p.userId != participant.userId).toList();
    _bloc.add(_UpdateParticipantsEvent(updatedParticipants));
  }
  
  @override
  void onParticipantUpdated(CallParticipant participant) {
    final updatedParticipants = _bloc.state.participants.map((p) {
      if (p.userId == participant.userId) {
        return participant;
      }
      return p;
    }).toList();
    _bloc.add(_UpdateParticipantsEvent(updatedParticipants));
  }
}

class _UpdateCallStatusEvent extends CallPageEvent {
  final CallStatus status;
  final String? errorMessage;
  
  const _UpdateCallStatusEvent(this.status, {this.errorMessage});
}

class _UpdateParticipantsEvent extends CallPageEvent {
  final List<CallParticipant> participants;
  
  const _UpdateParticipantsEvent(this.participants);
}
