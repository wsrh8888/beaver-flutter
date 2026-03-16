abstract class CallEvent {
  const CallEvent();
}

class LoadCallInfoEvent extends CallEvent {
  final String conversationId;

  const LoadCallInfoEvent(this.conversationId);
}

class StartCallEvent extends CallEvent {
  final String conversationId;

  const StartCallEvent(this.conversationId);
}

class EndCallEvent extends CallEvent {
  const EndCallEvent();
}
