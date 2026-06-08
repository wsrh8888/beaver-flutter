import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/moment/detail/bloc/event.dart';
import 'package:beaver/features/moment/detail/bloc/state.dart';
import 'package:beaver/features/moment/detail/data/repositories/repository.dart';
import 'package:beaver/types/api/moment.dart';

class MomentDetailBloc extends Bloc<MomentDetailEvent, MomentDetailState> {
  final MomentDetailRepository _repository;
  static const int _commentLimit = 20;
  static const int _childLimit = 20;

  MomentDetailBloc({MomentDetailRepository? repository})
      : _repository = repository ?? MomentDetailRepository(),
        super(const MomentDetailState()) {
    on<LoadMomentDetailEvent>(_onLoadDetail);
    on<RefreshMomentDetailEvent>(_onRefresh);
    on<LoadMoreCommentsEvent>(_onLoadMoreComments);
    on<LoadChildCommentsEvent>(_onLoadChildComments);
    on<AddCommentEvent>(_onAddComment);
    on<ToggleLikeEvent>(_onToggleLike);
    on<SetReplyTargetEvent>(_onSetReplyTarget);
    on<SwitchTabEvent>(_onSwitchTab);
  }

  Future<void> _onLoadDetail(
    LoadMomentDetailEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    emit(state.copyWith(status: MomentDetailStatus.loading, commentPage: 1));

    final detail = await _repository.loadDetail(event.momentId);
    if (detail == null) {
      emit(state.copyWith(
        status: MomentDetailStatus.error,
        errorMessage: '??????',
      ));
      return;
    }

    final comments = await _repository.loadRootComments(
      event.momentId,
      1,
      _commentLimit,
    );
    final likes = await _repository.loadLikes(event.momentId, 1, 50);

    final moment = _mergeMomentData(detail, comments: comments, likes: likes);

    emit(state.copyWith(
      status: MomentDetailStatus.success,
      moment: moment,
      commentPage: 1,
      hasMoreComments: comments.length < (moment.commentCount),
      childPageMap: const {},
    ));
  }

  Future<void> _onRefresh(
    RefreshMomentDetailEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    final momentId = state.moment?.id;
    if (momentId == null) return;

    final detail = await _repository.loadDetail(momentId);
    if (detail == null) return;

    final comments = await _repository.loadRootComments(
      momentId,
      1,
      _commentLimit,
    );
    final likes = await _repository.loadLikes(momentId, 1, 50);
    final moment = _mergeMomentData(detail, comments: comments, likes: likes);

    emit(state.copyWith(
      moment: moment,
      commentPage: 1,
      hasMoreComments: comments.length < moment.commentCount,
      childPageMap: const {},
      clearReplyTarget: true,
    ));
  }

  Future<void> _onLoadMoreComments(
    LoadMoreCommentsEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    final moment = state.moment;
    if (moment == null || !state.hasMoreComments || state.isLoadingComments) {
      return;
    }

    emit(state.copyWith(isLoadingComments: true));

    final nextPage = state.commentPage + 1;
    final moreComments = await _repository.loadRootComments(
      moment.id,
      nextPage,
      _commentLimit,
    );

    if (moreComments.isEmpty) {
      emit(state.copyWith(isLoadingComments: false, hasMoreComments: false));
      return;
    }

    final mergedComments = [...moment.comments, ...moreComments];
    final updatedMoment = _copyMoment(moment, comments: mergedComments);

    emit(state.copyWith(
      moment: updatedMoment,
      commentPage: nextPage,
      hasMoreComments: mergedComments.length < moment.commentCount,
      isLoadingComments: false,
    ));
  }

  Future<void> _onLoadChildComments(
    LoadChildCommentsEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    final moment = state.moment;
    if (moment == null) return;

    final root = event.rootComment;
    final currentPage = state.childPageMap[root.id] ?? 0;
    final nextPage = currentPage + 1;

    final result = await _repository.loadChildComments(
      moment.id,
      root.id,
      nextPage,
      _childLimit,
    );

    final comments = List<IMomentCommentModel>.from(moment.comments);
    final rootIndex = comments.indexWhere((c) => c.id == root.id);
    if (rootIndex < 0) return;

    final existingRoot = comments[rootIndex];
    final existingChildren = existingRoot.children ?? [];
    final mergedChildren = nextPage == 1
        ? result.list
        : [...existingChildren, ...result.list];

    comments[rootIndex] = IMomentCommentModel(
      id: existingRoot.id,
      momentId: existingRoot.momentId,
      userId: existingRoot.userId,
      userName: existingRoot.userName,
      nickName: existingRoot.nickName,
      avatar: existingRoot.avatar,
      content: existingRoot.content,
      childCount: result.count > 0 ? result.count : existingRoot.childCount,
      parentId: existingRoot.parentId,
      replyToCommentId: existingRoot.replyToCommentId,
      replyToUserName: existingRoot.replyToUserName,
      children: mergedChildren,
      createdAt: existingRoot.createdAt,
    );

    final childPageMap = Map<String, int>.from(state.childPageMap);
    childPageMap[root.id] = nextPage;

    emit(state.copyWith(
      moment: _copyMoment(moment, comments: comments),
      childPageMap: childPageMap,
    ));
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    final moment = state.moment;
    if (moment == null || event.content.trim().isEmpty) return;

    String? parentId;
    String? replyToCommentId;
    final target = event.targetComment;
    if (target != null) {
      replyToCommentId = target.id;
      parentId = (target.parentId?.isNotEmpty == true)
          ? target.parentId
          : target.id;
    }

    final res = await _repository.addComment(
      momentId: moment.id,
      content: event.content.trim(),
      parentId: parentId,
      replyToCommentId: replyToCommentId,
    );

    if (res == null) {
      emit(state.copyWith(errorMessage: '????'));
      return;
    }

    final newComment = IMomentCommentModel(
      id: res.id,
      momentId: moment.id,
      userId: res.userId,
      userName: res.userName,
      avatar: res.avatar,
      content: res.content,
      parentId: res.parentId.isNotEmpty ? res.parentId : null,
      replyToCommentId:
          res.replyToCommentId.isNotEmpty ? res.replyToCommentId : null,
      replyToUserName: res.replyToUserName,
      createdAt: res.createdAt,
    );

    var comments = List<IMomentCommentModel>.from(moment.comments);

    if (parentId == null || parentId.isEmpty) {
      comments.insert(0, newComment);
    } else {
      final rootIndex = comments.indexWhere((c) => c.id == parentId);
      if (rootIndex >= 0) {
        final root = comments[rootIndex];
        final children = List<IMomentCommentModel>.from(root.children ?? []);
        final insertAfterIdx =
            children.indexWhere((c) => c.id == replyToCommentId);
        if (insertAfterIdx >= 0) {
          children.insert(insertAfterIdx + 1, newComment);
        } else {
          children.add(newComment);
        }
        comments[rootIndex] = IMomentCommentModel(
          id: root.id,
          momentId: root.momentId,
          userId: root.userId,
          userName: root.userName,
          nickName: root.nickName,
          avatar: root.avatar,
          content: root.content,
          childCount: (root.childCount ?? 0) + 1,
          parentId: root.parentId,
          replyToCommentId: root.replyToCommentId,
          replyToUserName: root.replyToUserName,
          children: children,
          createdAt: root.createdAt,
        );
      } else {
        comments.insert(0, newComment);
      }
    }

    emit(state.copyWith(
      moment: _copyMoment(
        moment,
        comments: comments,
        commentCount: moment.commentCount + 1,
      ),
      clearReplyTarget: true,
    ));
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<MomentDetailState> emit,
  ) async {
    final moment = state.moment;
    if (moment == null) return;

    final nextStatus = !moment.isLiked;
    final success = await _repository.toggleLike(moment.id, nextStatus);
    if (!success) {
      emit(state.copyWith(errorMessage: '????'));
      return;
    }

    var likes = List<IMomentLikeModel>.from(moment.likes);
    var likeCount = moment.likeCount;

    if (nextStatus) {
      final existed = likes.any((like) => like.userId == event.currentUserId);
      if (!existed) {
        likes.insert(
          0,
          IMomentLikeModel(
            id: '',
            momentId: moment.id,
            userId: event.currentUserId,
            userName: event.currentUserName,
            avatar: event.currentUserAvatar,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
        likeCount += 1;
      }
    } else {
      final existed = likes.any((like) => like.userId == event.currentUserId);
      if (existed) {
        likes.removeWhere((like) => like.userId == event.currentUserId);
        likeCount = likeCount > 0 ? likeCount - 1 : 0;
      }
    }

    emit(state.copyWith(
      moment: _copyMoment(
        moment,
        likes: likes,
        likeCount: likeCount,
        isLiked: nextStatus,
      ),
    ));
  }

  void _onSetReplyTarget(
    SetReplyTargetEvent event,
    Emitter<MomentDetailState> emit,
  ) {
    emit(state.copyWith(replyTarget: event.target));
  }

  void _onSwitchTab(SwitchTabEvent event, Emitter<MomentDetailState> emit) {
    emit(state.copyWith(activeTab: event.tab));
  }

  IMomentListItem _mergeMomentData(
    IMomentListItem detail, {
    required List<IMomentCommentModel> comments,
    required List<IMomentLikeModel> likes,
  }) {
    return IMomentListItem(
      id: detail.id,
      userId: detail.userId,
      userName: detail.userName,
      avatar: detail.avatar,
      content: detail.content,
      files: detail.files,
      likes: likes.isNotEmpty ? likes : detail.likes,
      comments: comments,
      commentCount: detail.commentCount,
      likeCount: likes.isNotEmpty ? likes.length : detail.likeCount,
      isLiked: detail.isLiked,
      createdAt: detail.createdAt,
    );
  }

  IMomentListItem _copyMoment(
    IMomentListItem moment, {
    List<IMomentCommentModel>? comments,
    List<IMomentLikeModel>? likes,
    int? commentCount,
    int? likeCount,
    bool? isLiked,
  }) {
    return IMomentListItem(
      id: moment.id,
      userId: moment.userId,
      userName: moment.userName,
      avatar: moment.avatar,
      content: moment.content,
      files: moment.files,
      likes: likes ?? moment.likes,
      comments: comments ?? moment.comments,
      commentCount: commentCount ?? moment.commentCount,
      likeCount: likeCount ?? moment.likeCount,
      isLiked: isLiked ?? moment.isLiked,
      createdAt: moment.createdAt,
    );
  }
}
