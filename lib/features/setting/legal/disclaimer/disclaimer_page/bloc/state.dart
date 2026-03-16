import 'package:beaver/features/disclaimer/disclaimer_page/data/models/disclaimer.dart';

enum DisclaimerStatus { initial, loading, success, error }

class DisclaimerState {
  final DisclaimerStatus status;
  final List<ProjectLink> projectLinks;
  final AuthorInfo? authorInfo;
  final String? errorMessage;

  const DisclaimerState({
    this.status = DisclaimerStatus.initial,
    this.projectLinks = const [],
    this.authorInfo,
    this.errorMessage,
  });

  DisclaimerState copyWith({
    DisclaimerStatus? status,
    List<ProjectLink>? projectLinks,
    AuthorInfo? authorInfo,
    String? errorMessage,
  }) {
    return DisclaimerState(
      status: status ?? this.status,
      projectLinks: projectLinks ?? this.projectLinks,
      authorInfo: authorInfo ?? this.authorInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
