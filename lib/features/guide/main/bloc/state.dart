import 'package:beaver/features/guide/main/data/models/guide.dart';

enum GuideStatus { initial, loading, success, error }

class GuideState {
  final GuideStatus status;
  final GuideConfig? guideConfig;
  final String? errorMessage;

  const GuideState({
    this.status = GuideStatus.initial,
    this.guideConfig,
    this.errorMessage,
  });

  GuideState copyWith({
    GuideStatus? status,
    GuideConfig? guideConfig,
    String? errorMessage,
  }) {
    return GuideState(
      status: status ?? this.status,
      guideConfig: guideConfig ?? this.guideConfig,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

