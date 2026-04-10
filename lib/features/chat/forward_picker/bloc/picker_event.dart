import 'package:equatable/equatable.dart';

abstract class ForwardPickerEvent extends Equatable {
  const ForwardPickerEvent();
  @override
  List<Object?> get props => [];
}

class LoadContactsEvent extends ForwardPickerEvent {
  final String? query;
  const LoadContactsEvent({this.query});
  @override
  List<Object?> get props => [query];
}

class ExecuteForwardEvent extends ForwardPickerEvent {
  final String targetId;
  final int forwardType; // 1:私聊 2:群聊
  const ExecuteForwardEvent({required this.targetId, required this.forwardType});
  @override
  List<Object?> get props => [targetId, forwardType];
}
