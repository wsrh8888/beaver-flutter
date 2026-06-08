import 'package:beaver/types/api/moment.dart';

enum MomentDetailStatus { initial, loading, success, error }

enum MomentDetailTab { comments, likes }

abstract class MomentDetailEvent {
  const MomentDetailEvent();
}

class LoadMomentDetailEvent extends MomentDetailEvent {
  final String momentId;
  const LoadMomentDetailEvent(this.momentId);
}

class RefreshMomentDetailEvent extends MomentDetailEvent {
  const RefreshMomentDetailEvent();
}

class LoadMoreCommentsEvent extends MomentDetailEvent {
  const LoadMoreCommentsEvent();
}

class LoadChildCommentsEvent extends MomentDetailEvent {
  final IMomentCommentModel rootComment;
  const LoadChildCommentsEvent(this.rootComment);
}

class AddCommentEvent extends MomentDetailEvent {
  final String content;
  final IMomentCommentModel? targetComment;

  const AddCommentEvent(this.content, {this.targetComment});
}

class ToggleLikeEvent extends MomentDetailEvent {
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatar;

  const ToggleLikeEvent({
    required this.currentUserId,
    required this.currentUserName,
    this.currentUserAvatar = '',
  });
}

class SetReplyTargetEvent extends MomentDetailEvent {
  final IMomentCommentModel? target;
  const SetReplyTargetEvent(this.target);
}

class SwitchTabEvent extends MomentDetailEvent {
  final MomentDetailTab tab;
  const SwitchTabEvent(this.tab);
}
