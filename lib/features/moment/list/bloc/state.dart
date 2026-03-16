import 'package:beaver/types/api/moment.dart';

enum MomentListStatus { initial, loading, success, error }

class MomentListState {
  final MomentListStatus status;
  final List<IMomentListItem> moments;
  final String? errorMessage;
  final int page;
  final bool hasMore;

  const MomentListState({
    this.status = MomentListStatus.initial,
    this.moments = const [],
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
  });

  MomentListState copyWith({
    MomentListStatus? status,
    List<IMomentListItem>? moments,
    String? errorMessage,
    int? page,
    bool? hasMore,
  }) {
    return MomentListState(
      status: status ?? this.status,
      moments: moments ?? this.moments,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
