import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/circle.dart';

abstract class CircleDetailEvent extends Equatable {
  const CircleDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCircleDetailEvent extends CircleDetailEvent {
  final String postId;

  const LoadCircleDetailEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class RefreshCircleDetailEvent extends CircleDetailEvent {
  const RefreshCircleDetailEvent();
}

class LoadMoreCircleCommentsEvent extends CircleDetailEvent {
  const LoadMoreCircleCommentsEvent();
}

class LoadChildCircleCommentsEvent extends CircleDetailEvent {
  final ICircleCommentItem rootComment;

  const LoadChildCircleCommentsEvent(this.rootComment);

  @override
  List<Object?> get props => [rootComment.commentId];
}

class AddCircleCommentEvent extends CircleDetailEvent {
  final String content;
  final ICircleCommentItem? targetComment;

  const AddCircleCommentEvent({
    required this.content,
    this.targetComment,
  });

  @override
  List<Object?> get props => [content, targetComment?.commentId];
}

class ToggleCircleDetailLikeEvent extends CircleDetailEvent {
  const ToggleCircleDetailLikeEvent();
}

class SetCircleReplyTargetEvent extends CircleDetailEvent {
  final ICircleCommentItem? target;

  const SetCircleReplyTargetEvent(this.target);

  @override
  List<Object?> get props => [target?.commentId];
}
