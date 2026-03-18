import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/mine/bloc/event.dart';
import 'package:beaver/features/user/mine/bloc/state.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/di/injection.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  final _userBusiness = getIt<UserBusiness>();

  MineBloc() : super(const MineState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<MineState> emit,
  ) async {
    emit(state.copyWith(status: MineStatus.loading));

    try {
      final userInfo = await _userBusiness.getMyUserInfo();
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

