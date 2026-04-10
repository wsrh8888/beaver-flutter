import 'package:equatable/equatable.dart';

abstract class ForwardDetailEvent extends Equatable {
  const ForwardDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchForwardDetailEvent extends ForwardDetailEvent {
  final String recordId;
  const FetchForwardDetailEvent(this.recordId);
  @override
  List<Object?> get props => [recordId];
}
