import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/qrcode/bloc/event.dart';
import 'package:beaver/features/user/qrcode/bloc/state.dart';
import 'package:beaver/features/user/qrcode/data/repositories/repository.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  final QrcodeRepository _repository;

  QrcodeBloc(this._repository) : super(const QrcodeState()) {
    on<LoadQrCodeEvent>(_onLoadQrCode);
    on<SaveQrCodeEvent>(_onSaveQrCode);
  }

  Future<void> _onLoadQrCode(
    LoadQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    emit(state.copyWith(status: QrcodeStatus.loading));

    try {
      final qrCodeData = await _repository.getQrCodeData();
      emit(state.copyWith(
        status: QrcodeStatus.success,
        qrCodeData: qrCodeData,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QrcodeStatus.error,
        errorMessage: '加载二维码失�? $e',
      ));
    }
  }

  Future<void> _onSaveQrCode(
    SaveQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    try {
      await _repository.saveQrCode();
      emit(state.copyWith(
        errorMessage: '已保存到相册',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '保存失败: $e',
      ));
    }
  }
}

