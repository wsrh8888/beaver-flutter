enum RegisterStatus {
  initial,
  loading,
  success,
  error,
}

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
  });
  
  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
