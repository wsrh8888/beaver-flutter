import 'package:equatable/equatable.dart';
import 'package:beaver/types/call.dart';

abstract class CallPageEvent extends Equatable {
  const CallPageEvent();
  
  @override
  List<Object?> get props => [];
}

class InitializeCallEvent extends CallPageEvent {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;
  final CallType callType;
  final bool isGroup;
  
  const InitializeCallEvent(this.conversationId, this.roomToken, this.liveKitUrl, this.callType, {this.isGroup = false});
  
  @override
  List<Object?> get props => [conversationId, roomToken, liveKitUrl, callType, isGroup];
}

class StartCallEvent extends CallPageEvent {
  const StartCallEvent();
}

class EndCallEvent extends CallPageEvent {
  const EndCallEvent();
}

class ToggleMuteEvent extends CallPageEvent {
  const ToggleMuteEvent();
}

class ToggleCameraEvent extends CallPageEvent {
  const ToggleCameraEvent();
}

class ToggleSpeakerEvent extends CallPageEvent {
  const ToggleSpeakerEvent();
}

class InviteParticipantsEvent extends CallPageEvent {
  final List<String> userIds;
  const InviteParticipantsEvent(this.userIds);
  
  @override
  List<Object?> get props => [userIds];
}
