import 'package:equatable/equatable.dart';
import 'package:beaver/types/call.dart';

class CallIncomingState extends Equatable {
  final CallStatus status;
  final CallInfo? callInfo;
  final String? errorMessage;
  
  const CallIncomingState({
    this.status = CallStatus.initial,
    this.callInfo,
    this.errorMessage,
  });
  
  @override
  List<Object?> get props => [status, callInfo, errorMessage];
  
  CallIncomingState copyWith({
    CallStatus? status,
    CallInfo? callInfo,
    String? errorMessage,
  }) {
    return CallIncomingState(
      status: status ?? this.status,
      callInfo: callInfo ?? this.callInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
