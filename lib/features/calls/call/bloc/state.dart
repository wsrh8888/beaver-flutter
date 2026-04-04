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
  final bool isLocalVideoSmall;
  
  const CallPageState({
    this.status = CallStatus.initial,
    this.participants = const [],
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = true,
    this.errorMessage,
    this.callType = CallType.audio,
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
      isLocalVideoSmall: isLocalVideoSmall ?? this.isLocalVideoSmall,
    );
  }
}
