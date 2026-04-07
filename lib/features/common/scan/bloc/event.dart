import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

class CheckPermissionEvent extends ScanEvent {}

class ScanResultEvent extends ScanEvent {
  final String code;

  const ScanResultEvent(this.code);

  @override
  List<Object?> get props => [code];
}

class ToggleTorchEvent extends ScanEvent {}

class ResetScannerEvent extends ScanEvent {}
