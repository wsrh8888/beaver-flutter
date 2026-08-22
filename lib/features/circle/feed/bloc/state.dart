import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/circle.dart';

enum CircleFeedStatus { initial, loading, success, error }

class CircleFeedState extends Equatable {
  final CircleFeedStatus status;
  final List<ICirclePostItem> posts;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  const CircleFeedState({
    this.status = CircleFeedStatus.initial,
    this.posts = const [],
    this.page = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  CircleFeedState copyWith({
    CircleFeedStatus? status,
    List<ICirclePostItem>? posts,
    int? page,
    bool? hasMore,
    String? errorMessage,
  }) {
    return CircleFeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, page, hasMore, errorMessage];
}
