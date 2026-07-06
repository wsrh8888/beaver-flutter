import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/workbench/home/bloc/event.dart';
import 'package:beaver/features/workbench/home/bloc/state.dart';
import 'package:beaver/features/workbench/home/data/repositories/repository.dart';

class WorkbenchHomeBloc extends Bloc<WorkbenchHomeEvent, WorkbenchHomeState> {
  final WorkbenchHomeRepository _repository;

  WorkbenchHomeBloc(this._repository) : super(const WorkbenchHomeState()) {
    on<LoadWorkbenchHomeEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadWorkbenchHomeEvent event,
    Emitter<WorkbenchHomeState> emit,
  ) async {
    emit(state.copyWith(status: WorkbenchHomeStatus.loading));

    final res = await _repository.loadApps();
    if (res.code != 0) {
      emit(state.copyWith(
        status: WorkbenchHomeStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '加载应用失败',
      ));
      return;
    }

    emit(state.copyWith(
      status: WorkbenchHomeStatus.success,
      appList: res.result?.list ?? [],
    ));
  }
}
