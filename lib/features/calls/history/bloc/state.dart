import 'package:equatable/equatable.dart';
import 'package:beaver/types/call.dart';

class CallHistoryState extends Equatable {
  final bool isLoading;
  final List<CallHistory> callHistoryList;
  final String? errorMessage;
  
  const CallHistoryState({
    this.isLoading = false,
    this.callHistoryList = const [],
    this.errorMessage,
  });
  
  @override
  List<Object?> get props => [isLoading, callHistoryList, errorMessage];
  
  CallHistoryState copyWith({
    bool? isLoading,
    List<CallHistory>? callHistoryList,
    String? errorMessage,
  }) {
    return CallHistoryState(
      isLoading: isLoading ?? this.isLoading,
      callHistoryList: callHistoryList ?? this.callHistoryList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
