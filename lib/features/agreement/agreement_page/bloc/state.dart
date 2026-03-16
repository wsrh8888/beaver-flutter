import 'package:beaver/features/agreement/agreement_page/data/models/agreement.dart';

enum AgreementStatus { initial, loading, success, error }

class AgreementState {
  final AgreementStatus status;
  final Agreement? agreement;
  final String? errorMessage;

  const AgreementState({
    this.status = AgreementStatus.initial,
    this.agreement,
    this.errorMessage,
  });

  AgreementState copyWith({
    AgreementStatus? status,
    Agreement? agreement,
    String? errorMessage,
  }) {
    return AgreementState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
