import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';
import 'package:ota_update/ota_update.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _repository;

  UpdateBloc(this._repository) : super(const UpdateState()) {
    on<CheckUpdateEvent>(_onCheckUpdate);
    on<OpenUpdateModalEvent>(_onOpenUpdateModal);
    on<CloseUpdateModalEvent>(_onCloseUpdateModal);
    on<DownloadUpdateEvent>(_onDownloadUpdate);
    on<UpdateProgressEvent>(_onUpdateProgress);
  }

  void _onOpenUpdateModal(
    OpenUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) {
    emit(state.copyWith(showUpdateModal: true));
    add(const CheckUpdateEvent());
  }

  Future<void> _onCheckUpdate(
    CheckUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    emit(state.copyWith(status: UpdateStatus.loading));
    try {
      final updateInfo = await _repository.checkUpdate(state.currentVersion);
      if (updateInfo != null) {
        emit(state.copyWith(
          status: UpdateStatus.success,
          updateInfo: updateInfo,
          showUpdateModal: true,
        ));
      } else {
        emit(state.copyWith(
          status: UpdateStatus.success,
          showUpdateModal: false,
          errorMessage: '当前已是最新版本',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onCloseUpdateModal(
    CloseUpdateModalEvent event,
    Emitter<UpdateState> emit,
  ) {
    emit(state.copyWith(showUpdateModal: false));
  }

  Future<void> _onDownloadUpdate(
    DownloadUpdateEvent event,
    Emitter<UpdateState> emit,
  ) async {
    final updateInfo = state.updateInfo;
    if (updateInfo == null || updateInfo.latestVersion == null) return;
    final downloadUrl = updateInfo.latestVersion!.downloadUrl;

    if (Platform.isAndroid) {
      try {
        emit(state.copyWith(
          updateInfo: updateInfo.copyWith(isDownloading: true, downloadProgress: 0)
        ));

        // 使用 OtaUpdate 执行热更新（下载并自动拉起安装）
        OtaUpdate().execute(downloadUrl).listen(
          (OtaEvent event) {
            if (event.status == OtaStatus.DOWNLOADING) {
              final progress = int.tryParse(event.value ?? '0') ?? 0;
              add(UpdateProgressEvent(progress));
            } else if (event.status == OtaStatus.INSTALLING) {
               add(const UpdateProgressEvent(100));
            } else if (event.status == OtaStatus.ALREADY_RUNNING_ERROR) {
               // 处理错误
            } else if (event.status != OtaStatus.DOWNLOADING && event.status != OtaStatus.INSTALLING) {
                // 其他异常状态处理
            }
          },
        );
      } catch (e) {
        emit(state.copyWith(status: UpdateStatus.error, errorMessage: '启动更新失败: $e'));
      }
    } else if (Platform.isIOS) {
       // iOS 跳转 AppStore
       final url = Uri.parse(downloadUrl);
       if (await canLaunchUrl(url)) {
         await launchUrl(url, mode: LaunchMode.externalApplication);
       }
    }
  }

  void _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<UpdateState> emit,
  ) {
    if (state.updateInfo != null) {
      emit(state.copyWith(
        updateInfo: state.updateInfo!.copyWith(
          downloadProgress: event.progress,
          isDownloading: event.progress < 100,
        ),
      ));
    }
  }
}
