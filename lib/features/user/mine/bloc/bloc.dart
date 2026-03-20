import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/mine/bloc/event.dart';
import 'package:beaver/features/user/mine/bloc/state.dart';
import 'package:beaver/features/user/profile/data/repositories/repository.dart';
import 'package:beaver/types/business/user.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  final ProfileRepository _profileRepository;

  MineBloc({ProfileRepository? profileRepository}) 
    : _profileRepository = profileRepository ?? ProfileRepository(),
      super(const MineState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<MineState> emit,
  ) async {
    emit(state.copyWith(status: MineStatus.loading));

    try {
      final profileUserInfo = await _profileRepository.getUserInfo();
      final userInfo = UserInfo(
        userId: profileUserInfo.userId,
        nickname: profileUserInfo.nickName,
        avatar: profileUserInfo.fileName,
        email: profileUserInfo.email,
        gender: profileUserInfo.gender,
        abstract: profileUserInfo.abstract,
      );
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

