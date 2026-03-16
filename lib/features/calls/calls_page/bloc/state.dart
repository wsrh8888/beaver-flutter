import 'package:beaver/features/calls/calls_page/data/models/call.dart';

enum CallStatus { initial, loading, connected, ended, error }

class CallState {
  final CallStatus status;
  final CallInfo? callInfo;
  final String? errorMessage;

  const CallState({
    this.status = CallStatus.initial,
    this.callInfo,
    this.errorMessage,
  });

  CallState copyWith({
    CallStatus? status,
    CallInfo? callInfo,
    String? errorMessage,
  }) {
    return CallState(
      status: status ?? this.status,
      callInfo: callInfo ?? this.callInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
