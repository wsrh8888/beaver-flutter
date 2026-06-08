import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CallListItemStatus { incoming, calling, active }

class CallListItem extends Equatable {
  final String roomId;
  final String callType;
  final String callerId;
  final String conversationId;
  final String? callerName;
  final String? callerAvatar;
  final CallListItemStatus status;
  final int timestamp;

  const CallListItem({
    required this.roomId,
    required this.callType,
    required this.callerId,
    required this.conversationId,
    this.callerName,
    this.callerAvatar,
    this.status = CallListItemStatus.incoming,
    this.timestamp = 0,
  });

  @override
  List<Object?> get props => [
    roomId,
    callType,
    callerId,
    conversationId,
    callerName,
    callerAvatar,
    status,
    timestamp,
  ];

  CallListItem copyWith({
    String? roomId,
    String? callType,
    String? callerId,
    String? conversationId,
    String? callerName,
    String? callerAvatar,
    CallListItemStatus? status,
    int? timestamp,
  }) {
    return CallListItem(
      roomId: roomId ?? this.roomId,
      callType: callType ?? this.callType,
      callerId: callerId ?? this.callerId,
      conversationId: conversationId ?? this.conversationId,
      callerName: callerName ?? this.callerName,
      callerAvatar: callerAvatar ?? this.callerAvatar,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class CallListStoreState extends Equatable {
  final List<CallListItem> calls;

  const CallListStoreState({this.calls = const []});

  List<CallListItem> get incomingCalls =>
      calls.where((c) => c.status == CallListItemStatus.incoming).toList();

  List<CallListItem> get activeCalls => calls
      .where(
        (c) =>
            c.status == CallListItemStatus.active ||
            c.status == CallListItemStatus.calling,
      )
      .toList();

  bool hasCall(String roomId) => calls.any((c) => c.roomId == roomId);

  @override
  List<Object?> get props => [calls];

  CallListStoreState copyWith({List<CallListItem>? calls}) {
    return CallListStoreState(calls: calls ?? this.calls);
  }
}

class CallListStore extends Cubit<CallListStoreState> {
  CallListStore() : super(const CallListStoreState());

  void addIncomingCall({
    required String roomId,
    required String callType,
    required String callerId,
    required String conversationId,
    int timestamp = 0,
    String? callerName,
    String? callerAvatar,
  }) {
    if (state.hasCall(roomId)) return;

    final calls = List<CallListItem>.from(state.calls)
      ..add(
        CallListItem(
          roomId: roomId,
          callType: callType,
          callerId: callerId,
          conversationId: conversationId,
          callerName: callerName,
          callerAvatar: callerAvatar,
          status: CallListItemStatus.incoming,
          timestamp: timestamp,
        ),
      );
    emit(state.copyWith(calls: calls));
  }

  void updateCallerInfo(
    String roomId, {
    String? name,
    String? avatar,
  }) {
    final calls = state.calls.map((call) {
      if (call.roomId != roomId) return call;
      return call.copyWith(
        callerName: name ?? call.callerName,
        callerAvatar: avatar ?? call.callerAvatar,
      );
    }).toList();
    emit(state.copyWith(calls: calls));
  }

  void updateCallStatus(String roomId, CallListItemStatus status) {
    final calls = state.calls.map((call) {
      if (call.roomId != roomId) return call;
      return call.copyWith(status: status);
    }).toList();
    emit(state.copyWith(calls: calls));
  }

  void removeCall(String roomId) {
    final calls = state.calls.where((c) => c.roomId != roomId).toList();
    emit(state.copyWith(calls: calls));
  }

  void clearAll() {
    emit(const CallListStoreState());
  }
}
