import 'package:beaver/features/moment/moment_page/data/models/moment.dart';

enum MomentStatus { initial, loading, success, error }

class MomentState {
  final MomentStatus status;
  final List<Moment> moments;
  final String? errorMessage;

  const MomentState({
    this.status = MomentStatus.initial,
    this.moments = const [],
    this.errorMessage,
  });

  MomentState copyWith({
    MomentStatus? status,
    List<Moment>? moments,
    String? errorMessage,
  }) {
    return MomentState(
      status: status ?? this.status,
      moments: moments ?? this.moments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
