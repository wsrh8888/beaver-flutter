enum ForgetStatus {
  initial,
  loading,
  success,
  error,
  sendingCode,
  resettingPassword,
}

class ForgetState {
  final ForgetStatus status;
  final String? errorMessage;
  final bool isCodeButtonDisabled;
  final int countdown;

  const ForgetState({
    this.status = ForgetStatus.initial,
    this.errorMessage,
    this.isCodeButtonDisabled = false,
    this.countdown = 60,
  });

  ForgetState copyWith({
    ForgetStatus? status,
    String? errorMessage,
    bool? isCodeButtonDisabled,
    int? countdown,
  }) {
    return ForgetState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isCodeButtonDisabled: isCodeButtonDisabled ?? this.isCodeButtonDisabled,
      countdown: countdown ?? this.countdown,
    );
  }
}
