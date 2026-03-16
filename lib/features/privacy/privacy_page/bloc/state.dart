import 'package:beaver/features/privacy/privacy_page/data/models/privacy.dart';

enum PrivacyStatus { initial, loading, success, error }

class PrivacyState {
  final PrivacyStatus status;
  final PrivacyPolicy? privacyPolicy;
  final String? errorMessage;

  const PrivacyState({
    this.status = PrivacyStatus.initial,
    this.privacyPolicy,
    this.errorMessage,
  });

  PrivacyState copyWith({
    PrivacyStatus? status,
    PrivacyPolicy? privacyPolicy,
    String? errorMessage,
  }) {
    return PrivacyState(
      status: status ?? this.status,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
