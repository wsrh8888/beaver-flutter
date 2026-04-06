import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/types/call.dart';
import 'event.dart';
import 'state.dart';

import 'package:beaver/store/user/user.dart';

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
    emit(state.copyWith(status: CallStatus.loading, callType: event.callType, isGroup: event.isGroup));
    try {
      await _callBusiness.initialize(event.conversationId, event.roomToken, event.liveKitUrl);
      emit(state.copyWith(status: CallStatus.connected));
    } catch (e) {
      emit(state.copyWith(status: CallStatus.error));
    }
  }

  Future<void> _onStartCall(StartCallEvent event, Emitter<CallPageState> emit) async {
    await _callBusiness.startCall();
  }

  Future<void> _onToggleMute(ToggleMuteEvent event, Emitter<CallPageState> emit) async {
    await _callBusiness.toggleMute();
    emit(state.copyWith(isMuted: !state.isMuted));
  }

  Future<void> _onToggleCamera(ToggleCameraEvent event, Emitter<CallPageState> emit) async {
    await _callBusiness.toggleCamera();
    emit(state.copyWith(isCameraOff: !state.isCameraOff));
  }

  Future<void> _onToggleSpeaker(ToggleSpeakerEvent event, Emitter<CallPageState> emit) async {
    await _callBusiness.toggleSpeaker();
    emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<CallPageState> emit) async {
    await _callBusiness.endCall();
    emit(state.copyWith(status: CallStatus.ended));
  }
  
  Future<void> _onInviteParticipants(InviteParticipantsEvent event, Emitter<CallPageState> emit) async {
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
