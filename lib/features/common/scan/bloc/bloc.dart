import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:beaver/features/common/scan/bloc/event.dart';
import 'package:beaver/features/common/scan/bloc/state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(const ScanState()) {
    on<CheckPermissionEvent>(_onCheckPermission);
    on<ScanResultEvent>(_onScanResult);
    on<ToggleTorchEvent>(_onToggleTorch);
    on<ResetScannerEvent>(_onResetScanner);
  }

  Future<void> _onCheckPermission(
    CheckPermissionEvent event,
    Emitter<ScanState> emit,
  ) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      emit(state.copyWith(status: ScanStatus.scanning));
    } else {
      final requestStatus = await Permission.camera.request();
      if (requestStatus.isGranted) {
        emit(state.copyWith(status: ScanStatus.scanning));
      } else {
        emit(state.copyWith(status: ScanStatus.permissionDenied));
      }
    }
  }

  void _onScanResult(
    ScanResultEvent event,
    Emitter<ScanState> emit,
  ) {
    if (state.status == ScanStatus.success) return;
    emit(state.copyWith(status: ScanStatus.success, result: event.code));
  }

  void _onToggleTorch(
    ToggleTorchEvent event,
    Emitter<ScanState> emit,
  ) {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  void _onResetScanner(
    ResetScannerEvent event,
    Emitter<ScanState> emit,
  ) {
    emit(state.copyWith(status: ScanStatus.scanning, result: null));
  }
}
