import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/user/profile/bloc/event.dart';
import 'package:beaver/features/user/profile/bloc/state.dart';
import 'package:beaver/features/user/profile/data/repositories/repository.dart';
import 'package:beaver/types/business/user.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({ProfileRepository? profileRepository}) 
    : _profileRepository = profileRepository ?? ProfileRepository(),
      super(const ProfileState()) {
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
        status: ProfileStatus.success,
        userInfo: userInfo,
        formData: {
          'nickname': profileUserInfo.nickName,
          'email': profileUserInfo.email,
          'bio': profileUserInfo.abstract,
          'gender': profileUserInfo.gender,
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
      final success = await _profileRepository.updateUserInfo({'nickName': state.formData['nickname']});
      if (success) {
        final updatedUserInfo = state.userInfo!.copyWith(nickname: state.formData['nickname']);
        final updatedModals = Map<String, bool>.from(state.modals);
        updatedModals['nickname'] = false;
        emit(state.copyWith(
          status: ProfileStatus.success,
          userInfo: updatedUserInfo,
          modals: updatedModals,
          errorMessage: '昵称更新成功',
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: '昵称更新失败'));
      }
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
      final success = await _profileRepository.updateEmail(
        state.formData['email'],
        state.formData['emailCode'],
      );
      if (success) {
        final updatedUserInfo = state.userInfo!.copyWith(email: state.formData['email']);
        final updatedModals = Map<String, bool>.from(state.modals);
        updatedModals['email'] = false;
        emit(state.copyWith(
          status: ProfileStatus.success,
          userInfo: updatedUserInfo,
          modals: updatedModals,
          errorMessage: '邮箱更新成功',
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: '邮箱更新失败'));
      }
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
      final success = await _profileRepository.updateUserInfo({'abstract': state.formData['bio']});
      if (success) {
        final updatedUserInfo = state.userInfo!.copyWith(abstract: state.formData['bio']);
        final updatedModals = Map<String, bool>.from(state.modals);
        updatedModals['description'] = false;
        emit(state.copyWith(
          status: ProfileStatus.success,
          userInfo: updatedUserInfo,
          modals: updatedModals,
          errorMessage: '个人简介更新成功',
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: '个人简介更新失败'));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '个人简介更新失败: $e',
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
      final success = await _profileRepository.updateUserInfo({'gender': state.formData['gender']});
      if (success) {
        final updatedUserInfo = state.userInfo!.copyWith(gender: state.formData['gender']);
        final updatedModals = Map<String, bool>.from(state.modals);
        updatedModals['gender'] = false;
        emit(state.copyWith(
          status: ProfileStatus.success,
          userInfo: updatedUserInfo,
          modals: updatedModals,
          errorMessage: '性别更新成功',
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: '性别更新失败'));
      }
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
      final success = await _profileRepository.sendEmailCode(state.formData['email']);
      if (success) {
        emit(state.copyWith(
          isCodeSending: false,
          countdown: 60,
          errorMessage: '验证码已发送',
        ));
        // 开始倒计时逻辑（简单处理，实际生产可能需要更稳健的计时器）
        for (int i = 59; i >= 0; i--) {
          if (emit.isDone) break;
          await Future.delayed(const Duration(seconds: 1));
          emit(state.copyWith(countdown: i));
        }
      } else {
        emit(state.copyWith(isCodeSending: false, errorMessage: '发送失败'));
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

    // 这里应该先选择图片并上传
    // 暂时保持空逻辑或使用模拟上传
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      // 假设上传后拿到 fileKey
      const mockFileKey = 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%20new&size=512x512';
      final success = await _profileRepository.updateUserInfo({'fileName': mockFileKey});
      if (success) {
        final updatedUserInfo = state.userInfo!.copyWith(avatar: mockFileKey);
        emit(state.copyWith(
          status: ProfileStatus.success,
          userInfo: updatedUserInfo,
          errorMessage: '头像更新成功',
        ));
      } else {
        emit(state.copyWith(status: ProfileStatus.error, errorMessage: '头像更新失败'));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: '头像更新失败: $e',
      ));
    }
  }
}
