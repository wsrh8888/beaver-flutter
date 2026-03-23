import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/qrcode/bloc/event.dart';
import 'package:beaver/features/user/qrcode/bloc/state.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/features/user/qrcode/data/models/qrcode.dart';
import 'package:beaver/di/injection.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  final UserBusiness _userBusiness = getIt<UserBusiness>();

  QrcodeBloc() : super(const QrcodeState()) {
    on<LoadQrCodeEvent>(_onLoadQrCode);
    on<SaveQrCodeEvent>(_onSaveQrCode);
  }

  Future<void> _onLoadQrCode(
    LoadQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    emit(state.copyWith(status: QrcodeStatus.loading));

    try {
      final userInfo = await _userBusiness.getMyUserInfo();
      emit(
        state.copyWith(
          status: QrcodeStatus.success,
          qrCodeData: QrCodeData(
            userId: userInfo.userId,
            nickname: userInfo.nickname,
            fileName: userInfo.avatar ?? '',
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: QrcodeStatus.error, errorMessage: '加载二维码失败 $e'),
      );
    }
  }

  Future<void> _onSaveQrCode(
    SaveQrCodeEvent event,
    Emitter<QrcodeState> emit,
  ) async {
    // 保存逻辑在页面处理，Bloc 仅用于状态
    emit(state.copyWith(errorMessage: '正在保存到相册...'));
  }
}
