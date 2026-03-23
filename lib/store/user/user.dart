import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/types/business/user.dart';
import 'package:beaver/store/contact/contact.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class UserStoreState extends Equatable {
  final AuthStatus authStatus;
  final String currentUserId;

  const UserStoreState({
    this.authStatus = AuthStatus.initial,
    this.currentUserId = '',
  });

  UserStoreState copyWith({AuthStatus? authStatus, String? currentUserId}) {
    return UserStoreState(
      authStatus: authStatus ?? this.authStatus,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  @override
  List<Object?> get props => [authStatus, currentUserId];
}

class UserStore extends Cubit<UserStoreState> {
  final UserBusiness _userBusiness;

  UserStore({UserBusiness? userBusiness})
    : _userBusiness = userBusiness ?? getIt<UserBusiness>(),
      super(const UserStoreState());

  /**
   * @description: 获取当前用户的完整信息 (对标 PC getUserInfo getter)
   * 业务方通过这个方法从 ContactStore 实时获取最新的资料
   */
  UserInfo? getUserInfo(ContactStore contactStore) {
    if (state.currentUserId.isEmpty) return null;
    return contactStore.getContact(state.currentUserId);
  }

  /**
   * @description: 初始化，确定 ID 并启动个人资料同步 (对标 PC init)
   */
  Future<void> init() async {
    try {
      final userInfo = await _userBusiness.getMyUserInfo();
      if (userInfo.userId.isNotEmpty && userInfo.userId != '未设置') {
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            currentUserId: userInfo.userId,
          ),
        );

        // 如果资料是初始化的（无头像且昵称为默认值），或者为了确保最新，触发同步
        // 在 AppStore 流程中，如果不等待同步完成，ContactStore 可能会读到旧数据
        // 所以这里我们选择“强制同步并入库”
        await _userBusiness.syncMyProfile();
      } else {
        emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
      }
    } catch (e) {
      print('UserStore: 初始化失败: $e');
    }
  }

  /**
   * @description: 更新个人资料 (对标 PC updateUserInfo)
   * 更新 API 后同步更新全局 ContactStore 以触发表界面刷新
   */
  Future<bool> updateProfile(
    UserInfo updates,
    ContactStore contactStore,
  ) async {
    final success = await _userBusiness.updateProfile(
      nickname: updates.nickname,
      avatar: updates.avatar,
      abstract: updates.abstract,
      gender: updates.gender,
    );

    if (success) {
      // 主动更新全局联系人缓存
      contactStore.updateContact(state.currentUserId, updates, force: true);
      return true;
    }
    return false;
  }

  void logout() {
    emit(const UserStoreState(authStatus: AuthStatus.unauthenticated));
  }
}
