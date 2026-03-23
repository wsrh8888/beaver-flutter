import 'package:equatable/equatable.dart';

abstract class GroupNotificationsEvent extends Equatable {
  const GroupNotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupNotificationsEvent extends GroupNotificationsEvent {
  const LoadGroupNotificationsEvent();
}

class SwitchTabEvent extends GroupNotificationsEvent {
  final String tab;
  const SwitchTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class AcceptGroupRequestEvent extends GroupNotificationsEvent {
  final int id;
  const AcceptGroupRequestEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RejectGroupRequestEvent extends GroupNotificationsEvent {
  final int id;
  const RejectGroupRequestEvent(this.id);

  @override
  List<Object?> get props => [id];
}
