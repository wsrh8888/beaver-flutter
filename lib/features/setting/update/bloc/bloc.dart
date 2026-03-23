import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository _repository;

  UpdateBloc(this._repository) : super(const UpdateState()) {
    on<CheckUpdateEvent>(_onCheckUpdate);
    on<CloseUpdateModalEvent>(_onCloseUpdateModal);
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
}
