import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/api/oauth.dart';
import 'package:beaver/features/oauth/scan/bloc/event.dart';
import 'package:beaver/features/oauth/scan/bloc/state.dart';
import 'package:beaver/types/api/oauth.dart';

class OAuthScanConfirmBloc extends Bloc<OAuthScanConfirmEvent, OAuthScanConfirmState> {
  OAuthScanConfirmBloc() : super(const OAuthScanConfirmState()) {
    on<OAuthScanConfirmInitEvent>(_onInit);
    on<OAuthScanConfirmSubmitEvent>(_onSubmit);
    on<OAuthScanConfirmCancelEvent>(_onCancel);
  }

  Future<void> _onInit(
    OAuthScanConfirmInitEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    emit(state.copyWith(status: OAuthScanConfirmStatus.loading, sceneId: event.sceneId));

    final sceneRes = await getQrCodeSceneApi(event.sceneId);
    if (sceneRes.code != 0 || sceneRes.result == null) {
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: sceneRes.msg.isNotEmpty ? sceneRes.msg : '扫码会话无效',
      ));
      return;
    }

    final scene = sceneRes.result!;
    if (scene.status == 'expired' || scene.status == 'cancelled' || scene.status == 'confirmed') {
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: '二维码已失效，请重新扫码',
      ));
      return;
    }

    final scanRes = await scanQrCodeApi(IScanQrCodeReq(sceneId: event.sceneId));
    if (scanRes.code != 0) {
      emit(state.copyWith(
        status: OAuthScanConfirmStatus.error,
        errorMessage: scanRes.msg.isNotEmpty ? scanRes.msg : '标记扫码失败',
      ));
      return;
    }

    emit(state.copyWith(
      status: OAuthScanConfirmStatus.ready,
      appName: scene.appName,
      appIcon: scene.appIcon,
      scopes: scene.scopes,
    ));
  }

  Future<void> _onSubmit(
    OAuthScanConfirmSubmitEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    if (state.sceneId.isEmpty) return;
    emit(state.copyWith(status: OAuthScanConfirmStatus.submitting));

    final res = await confirmQrCodeApi(IConfirmQrCodeReq(sceneId: state.sceneId));
    if (res.code == 0) {
      emit(state.copyWith(status: OAuthScanConfirmStatus.success));
      return;
    }

    emit(state.copyWith(
      status: OAuthScanConfirmStatus.ready,
      errorMessage: res.msg.isNotEmpty ? res.msg : '授权失败',
    ));
  }

  Future<void> _onCancel(
    OAuthScanConfirmCancelEvent event,
    Emitter<OAuthScanConfirmState> emit,
  ) async {
    if (state.sceneId.isNotEmpty) {
      await cancelQrCodeApi(ICancelQrCodeReq(sceneId: state.sceneId));
    }
  }
}
