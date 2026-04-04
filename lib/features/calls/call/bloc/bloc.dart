import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/types/call.dart';
import 'event.dart';
import 'state.dart';

class CallPageBloc extends Bloc<CallPageEvent, CallPageState> {
  final CallStore _callStore;
  final CallBusiness _callBusiness;
  StreamSubscription? _storeSubscription;

  CallPageBloc({
    CallStore? callStore,
    CallBusiness? callBusiness,
  }) : _callStore = callStore ?? getIt<CallStore>(),
       _callBusiness = callBusiness ?? getIt<CallBusiness>(),
       super(const CallPageState()) {
    on<InitializeCallEvent>(_onInitialize);
    on<StartCallEvent>(_onStartCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);
    on<EndCallEvent>(_onEndCall);
    on<_UpdateFromStoreEvent>(_onUpdateFromStore);

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
    emit(state.copyWith(status: CallStatus.loading, callType: event.callType));
    try {
      await _callBusiness.initialize(event.roomToken, event.liveKitUrl);
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
  
  void _onUpdateFromStore(_UpdateFromStoreEvent event, Emitter<CallPageState> emit) {
    emit(state.copyWith(participants: event.storeState.members));
  }

  CallParticipant? get localParticipant {
      // 这里的逻辑应对齐 PC 版，找到成员列表中“自己”的那一项
      final members = _callStore.state.members;
      if (members.isEmpty) return null;
      // 简单起见，目前假设第一个是自己（由 initialize 中 upsert 顺序决定）
      return members.firstWhere((p) => p.name == '我', orElse: () => members[0]);
  }
}

class _UpdateFromStoreEvent extends CallPageEvent {
  final CallStoreState storeState;
  const _UpdateFromStoreEvent(this.storeState);
}
