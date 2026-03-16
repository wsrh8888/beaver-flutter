import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/update/update_page/bloc/event.dart';
import 'package:beaver/features/update/update_page/bloc/state.dart';
import 'package:beaver/features/update/update_page/data/repositories/repository.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _repository;

  UpdateBloc(this._repository) : super(const UpdateState()) {
    on<CheckUpdateEvent>(_onCheckUpdate);
    on<OpenUpdateModalEvent>(_onOpenUpdateModal);
    on<CloseUpdateModalEvent>(_onCloseUpdateModal);
    on<DownloadUpdateEvent>(_onDownloadUpdate);
  }

  Future<void> _onCheckUpdate(
    CheckUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(status: UpdateStatus.loading));

    try {
      final updateInfo = await _repository.checkUpdate(state.currentVersion);
      emit(state.copyWith(
        status: UpdateStatus.success,
        updateInfo: updateInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: '检查更新失败: $e',
      ));
    }
  }

  Future<void> _onOpenUpdateModal(
    OpenUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(showUpdateModal: true));
    add(CheckUpdateEvent());
  }

  Future<void> _onCloseUpdateModal(
    CloseUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(showUpdateModal: false));
  }

  Future<void> _onDownloadUpdate(
    DownloadUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    if (state.updateInfo?.latestVersion == null) return;

    final updatedUpdateInfo = UpdateInfo(
      hasUpdate: state.updateInfo!.hasUpdate,
      latestVersion: state.updateInfo!.latestVersion,
      isChecking: false,
      isDownloading: true,
      downloadProgress: 0,
      lastCheckTime: state.updateInfo!.lastCheckTime,
    );

    emit(state.copyWith(updateInfo: updatedUpdateInfo));

    try {
      await _repository.downloadUpdate(state.updateInfo!.latestVersion!.downloadUrl);
      final completedUpdateInfo = UpdateInfo(
        hasUpdate: state.updateInfo!.hasUpdate,
        latestVersion: state.updateInfo!.latestVersion,
        isChecking: false,
        isDownloading: false,
        downloadProgress: 100,
        lastCheckTime: state.updateInfo!.lastCheckTime,
      );
      emit(state.copyWith(
        updateInfo: completedUpdateInfo,
        errorMessage: '下载完成',
      ));
    } catch (e) {
      final failedUpdateInfo = UpdateInfo(
        hasUpdate: state.updateInfo!.hasUpdate,
        latestVersion: state.updateInfo!.latestVersion,
        isChecking: false,
        isDownloading: false,
        downloadProgress: 0,
        lastCheckTime: state.updateInfo!.lastCheckTime,
      );
      emit(state.copyWith(
        updateInfo: failedUpdateInfo,
        errorMessage: '下载失败: $e',
      ));
    }
  }
}
