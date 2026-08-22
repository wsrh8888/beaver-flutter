import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/circle.dart';

enum CircleDetailStatus { initial, loading, success, error }

class CircleDetailState extends Equatable {
  final CircleDetailStatus status;
  final IGetPostDetailRes? post;
  final ICircleCommentItem? replyTarget;
  final int commentPage;
  final bool hasMoreComments;
  final bool isLoadingComments;
  final Map<String, int> childPageMap;
  final String? errorMessage;

  const CircleDetailState({
    this.status = CircleDetailStatus.initial,
    this.post,
    this.replyTarget,
    this.commentPage = 1,
    this.hasMoreComments = true,
    this.isLoadingComments = false,
    this.childPageMap = const {},
    this.errorMessage,
  });

  CircleDetailState copyWith({
    CircleDetailStatus? status,
    IGetPostDetailRes? post,
    ICircleCommentItem? replyTarget,
    bool clearReplyTarget = false,
    int? commentPage,
    bool? hasMoreComments,
    bool? isLoadingComments,
    Map<String, int>? childPageMap,
    String? errorMessage,
  }) {
    return CircleDetailState(
      status: status ?? this.status,
      post: post ?? this.post,
      replyTarget: clearReplyTarget ? null : (replyTarget ?? this.replyTarget),
      commentPage: commentPage ?? this.commentPage,
      hasMoreComments: hasMoreComments ?? this.hasMoreComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      childPageMap: childPageMap ?? this.childPageMap,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        post,
        replyTarget,
        commentPage,
        hasMoreComments,
        isLoadingComments,
        childPageMap,
        errorMessage,
      ];
}
