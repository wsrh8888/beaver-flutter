import 'package:equatable/equatable.dart';

abstract class CallHistoryEvent extends Equatable {
  const CallHistoryEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadCallHistoryEvent extends CallHistoryEvent {
  const LoadCallHistoryEvent();
}

class DeleteCallHistoryEvent extends CallHistoryEvent {
  final String callId;
  
  const DeleteCallHistoryEvent(this.callId);
  
  @override
  List<Object?> get props => [callId];
}

class ClearCallHistoryEvent extends CallHistoryEvent {
  const ClearCallHistoryEvent();
}
