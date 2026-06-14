import 'package:beaver/types/api/moment.dart';
import 'package:beaver/features/moment/detail/bloc/event.dart';

class MomentDetailState {
  final MomentDetailStatus status;
  final IMomentListItem? moment;
  final String? errorMessage;
  final MomentDetailTab activeTab;
  final IMomentCommentModel? replyTarget;
  final int commentPage;
  final bool hasMoreComments;
  final bool isLoadingComments;
  final Map<String, int> childPageMap;

  const MomentDetailState({
    this.status = MomentDetailStatus.initial,
    this.moment,
    this.errorMessage,
    this.activeTab = MomentDetailTab.comments,
    this.replyTarget,
    this.commentPage = 1,
    this.hasMoreComments = false,
    this.isLoadingComments = false,
    this.childPageMap = const {},
  });

  MomentDetailState copyWith({
    MomentDetailStatus? status,
    IMomentListItem? moment,
    String? errorMessage,
    MomentDetailTab? activeTab,
    IMomentCommentModel? replyTarget,
    bool clearReplyTarget = false,
    int? commentPage,
    bool? hasMoreComments,
    bool? isLoadingComments,
    Map<String, int>? childPageMap,
  }) {
    return MomentDetailState(
      status: status ?? this.status,
      moment: moment ?? this.moment,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
      replyTarget: clearReplyTarget ? null : (replyTarget ?? this.replyTarget),
      commentPage: commentPage ?? this.commentPage,
      hasMoreComments: hasMoreComments ?? this.hasMoreComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      childPageMap: childPageMap ?? this.childPageMap,
    );
  }
}
