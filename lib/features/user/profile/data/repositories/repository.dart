import 'package:beaver/di/injection.dart';
import 'package:beaver/features/user/profile/data/models/profile.dart' as profile_model;
import 'package:beaver/types/business/user.dart';

class ProfileRepository {
  final UserRepositoryInterface _userRepository;

  ProfileRepository({UserRepositoryInterface? userRepository}) 
    : _userRepository = userRepository ?? getIt<UserRepositoryInterface>();

  Future<profile_model.UserInfo> getUserInfo() async {
    final user = await _userRepository.getMyUserInfo();
    return profile_model.UserInfo(
      userId: user.userId,
      nickName: user.nickname,
      fileName: user.avatar ?? '',
      email: user.email ?? '',
      gender: user.gender,
      abstract: user.abstract,
    );
  }

  Future<bool> updateUserInfo(Map<String, dynamic> updates) async {
    return _userRepository.updateProfile(
      nickname: updates['nickName'],
      avatar: updates['fileName'],
      abstract: updates['abstract'],
      gender: updates['gender'],
    );
  }

  Future<bool> sendEmailCode(String email) async {
    return _userRepository.getEmailCode(email, 'update_email');
  }

  Future<bool> updateEmail(String email, String code) async {
    return _userRepository.updateEmail(email, code);
  }
}

