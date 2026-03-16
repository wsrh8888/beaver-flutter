import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/profile/bloc/event.dart';
import 'package:beaver/features/user/profile/bloc/state.dart';
import 'package:beaver/features/user/profile/data/repositories/repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
    on<OpenModalEvent>(_onOpenModal);
    on<CloseModalEvent>(_onCloseModal);
    on<UpdateFormDataEvent>(_onUpdateFormData);
    on<SaveNicknameEvent>(_onSaveNickname);
    on<SaveEmailEvent>(_onSaveEmail);
    on<SaveBioEvent>(_onSaveBio);
    on<SaveGenderEvent>(_onSaveGender);
    on<SendEmailCodeEvent>(_onSendEmailCode);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final userInfo = await _repository.getUserInfo();
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: userInfo,
        formData: {
          'nickname': userInfo.nickName,
          'email': userInfo.email,
          'bio': userInfo.abstract ?? '',
          'gender': userInfo.gender,
          'emailCode': '',
        },
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '加载用户信息失败: $e',
      ));
    }
  }

  Future<void> _onOpenModal(
    OpenModalEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedModals = Map<String, bool>.from(state.modals);
    updatedModals[event.modalType] = true;
    emit(state.copyWith(modals: updatedModals));
  }

  Future<void> _onCloseModal(
    CloseModalEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedModals = Map<String, bool>.from(state.modals);
    updatedModals[event.modalType] = false;
    emit(state.copyWith(modals: updatedModals));
  }

  Future<void> _onUpdateFormData(
    UpdateFormDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedFormData = Map<String, dynamic>.from(state.formData);
    updatedFormData[event.key] = event.value;
    emit(state.copyWith(formData: updatedFormData));
  }

  Future<void> _onSaveNickname(
    SaveNicknameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await _repository.updateUserInfo({'nickName': state.formData['nickname']});
      final updatedUserInfo = state.userInfo!.copyWith(nickName: state.formData['nickname']);
      final updatedModals = Map<String, bool>.from(state.modals);
      updatedModals['nickname'] = false;
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: updatedUserInfo,
        modals: updatedModals,
        errorMessage: '昵称更新成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '昵称更新失败: $e',
      ));
    }
  }

  Future<void> _onSaveEmail(
    SaveEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await _repository.updateEmail(
        state.formData['email'],
        state.formData['emailCode'],
      );
      final updatedUserInfo = state.userInfo!.copyWith(email: state.formData['email']);
      final updatedModals = Map<String, bool>.from(state.modals);
      updatedModals['email'] = false;
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: updatedUserInfo,
        modals: updatedModals,
        errorMessage: '邮箱更新成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '邮箱更新失败: $e',
      ));
    }
  }

  Future<void> _onSaveBio(
    SaveBioEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await _repository.updateUserInfo({'abstract': state.formData['bio']});
      final updatedUserInfo = state.userInfo!.copyWith(abstract: state.formData['bio']);
      final updatedModals = Map<String, bool>.from(state.modals);
      updatedModals['description'] = false;
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: updatedUserInfo,
        modals: updatedModals,
        errorMessage: '个人简介更新成�?,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '个人简介更新失�? $e',
      ));
    }
  }

  Future<void> _onSaveGender(
    SaveGenderEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await _repository.updateUserInfo({'gender': state.formData['gender']});
      final updatedUserInfo = state.userInfo!.copyWith(gender: state.formData['gender']);
      final updatedModals = Map<String, bool>.from(state.modals);
      updatedModals['gender'] = false;
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: updatedUserInfo,
        modals: updatedModals,
        errorMessage: '性别更新成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '性别更新失败: $e',
      ));
    }
  }

  Future<void> _onSendEmailCode(
    SendEmailCodeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(
      isCodeSending: true,
      errorMessage: '发送验证码...',
    ));

    try {
      await _repository.sendEmailCode(state.formData['email']);
      // 开始倒计�?
      emit(state.copyWith(
        isCodeSending: false,
        countdown: 60,
        errorMessage: '验证码已发�?,
      ));
      // 模拟倒计�?
      for (int i = 59; i >= 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(countdown: i));
      }
    } catch (e) {
      emit(state.copyWith(
        isCodeSending: false,
        errorMessage: '发送验证码失败: $e',
      ));
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // 模拟更换头像
      await _repository.updateUserInfo({'fileName': 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%20new&size=512x512'});
      final updatedUserInfo = state.userInfo!.copyWith(
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%20new&size=512x512',
      );
      emit(state.copyWith(
        status: ProfileStatus.success,
        userInfo: updatedUserInfo,
        errorMessage: '头像更新成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '头像更新失败: $e',
      ));
    }
  }
}

