import 'package:equatable/equatable.dart';
import 'package:beaver/types/call.dart';

abstract class CallIncomingEvent extends Equatable {
  const CallIncomingEvent();
  
  @override
  List<Object?> get props => [];
}

class AcceptCallEvent extends CallIncomingEvent {
  const AcceptCallEvent();
}

class RejectCallEvent extends CallIncomingEvent {
  const RejectCallEvent();
}

class LoadCallInfoEvent extends CallIncomingEvent {
  final String conversationId;
  
  const LoadCallInfoEvent(this.conversationId);
  
  @override
  List<Object?> get props => [conversationId];
}
