import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/mine/mine_page/bloc/event.dart';
import 'package:beaver/features/mine/mine_page/bloc/state.dart';
import 'package:beaver/features/mine/mine_page/data/repositories/repository.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  final MineRepository _repository;

  MineBloc(this._repository) : super(const MineState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<MineState> emit,
  ) async {
    emit(state.copyWith(status: MineStatus.loading));

    try {
      final userInfo = await _repository.getUserInfo();
      emit(state.copyWith(
        status: MineStatus.success,
        userInfo: userInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MineStatus.error,
        errorMessage: '加载用户信息失败: $e',
      ));
    }
  }
}
