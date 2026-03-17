import 'package:equatable/equatable.dart';
import 'package:beaver/features/calls/core/call_manager.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallPageState extends Equatable {
  final CallStatus status;
  final List<CallParticipant> participants;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final String? errorMessage;
  
  const CallPageState({
    this.status = CallStatus.initial,
    this.participants = const [],
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = true,
    this.errorMessage,
  });
  
  @override
  List<Object?> get props => [
    status,
    participants,
    isMuted,
    isCameraOff,
    isSpeakerOn,
    errorMessage,
  ];
  
  CallPageState copyWith({
    CallStatus? status,
    List<CallParticipant>? participants,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    String? errorMessage,
  }) {
    return CallPageState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
