import 'package:equatable/equatable.dart';

enum ScanStatus { initial, scanning, success, error, permissionDenied }

class ScanState extends Equatable {
  final ScanStatus status;
  final String? result;
  final String? errorMessage;
  final bool isTorchOn;

  const ScanState({
    this.status = ScanStatus.initial,
    this.result,
    this.errorMessage,
    this.isTorchOn = false,
  });

  ScanState copyWith({
    ScanStatus? status,
    String? result,
    String? errorMessage,
    bool? isTorchOn,
  }) {
    return ScanState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      isTorchOn: isTorchOn ?? this.isTorchOn,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage, isTorchOn];
}
