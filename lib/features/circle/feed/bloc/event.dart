import 'package:equatable/equatable.dart';

abstract class CircleFeedEvent extends Equatable {
  const CircleFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadCircleFeedEvent extends CircleFeedEvent {
  final bool refresh;

  const LoadCircleFeedEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class ToggleLikeCirclePostEvent extends CircleFeedEvent {
  final String postId;

  const ToggleLikeCirclePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
