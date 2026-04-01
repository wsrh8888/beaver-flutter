import 'package:equatable/equatable.dart';

abstract class CallPageEvent extends Equatable {
  const CallPageEvent();
  
  @override
  List<Object?> get props => [];
}

class InitializeCallEvent extends CallPageEvent {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;
  
  const InitializeCallEvent(this.conversationId, this.roomToken, this.liveKitUrl);
  
  @override
  List<Object?> get props => [conversationId, roomToken, liveKitUrl];
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
