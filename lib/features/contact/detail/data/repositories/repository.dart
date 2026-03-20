import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/detail/data/models/user_info.dart' as detail_model;
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user.dart';

class DetailRepository {
  final FriendRepositoryInterface _friendRepository;
  final UserRepositoryInterface _userRepository;

  DetailRepository({
    FriendRepositoryInterface? friendRepository,
    UserRepositoryInterface? userRepository,
  })  : _friendRepository = friendRepository ?? getIt<FriendRepositoryInterface>(),
        _userRepository = userRepository ?? getIt<UserRepositoryInterface>();

  Future<detail_model.UserInfo> getUserInfo(String userId) async {
    final user = await _userRepository.getUserProfile(userId);
    if (user != null) {
      return detail_model.UserInfo(
          userId: user.userId,
          nickname: user.nickName,
          fileName: user.avatar ?? '',
          remarkName: '',
          signature: user.abstract,
          gender: user.gender == 1 ? 'male' : 'female',
          location: '',
          age: '',
          constellation: '',
          occupation: '',
          education: '',
          hobbies: '',
          photos: [],
          conversationId: 'conv_$userId',
          source: 'search',
        );
    }
    return detail_model.UserInfo(
      userId: userId,
      nickname: '未知用户',
      fileName: '',
      remarkName: '',
      signature: '',
      gender: 'male',
      location: '',
      age: '',
      constellation: '',
      occupation: '',
      education: '',
      hobbies: '',
      photos: [],
      conversationId: 'conv_$userId',
      source: 'search',
    );
  }

  Future<bool> updateRemarkName(String userId, String remarkName) async {
    // TODO: 实现更新备注名称逻辑
    return true;
  }

  Future<bool> deleteFriend(String userId) async {
    await _friendRepository.deleteFriend(userId);
    return true;
  }
}

