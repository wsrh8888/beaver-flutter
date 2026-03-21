import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/types/business/user.dart';

class ContactStoreState extends Equatable {
  final Map<String, UserInfo> userMap;
  final int version; // 用于触发响应式更新

  const ContactStoreState({this.userMap = const {}, this.version = 0});

  ContactStoreState copyWith({Map<String, UserInfo>? userMap, int? version}) {
    return ContactStoreState(
      userMap: userMap ?? this.userMap,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [userMap, version];
}

class ContactStore extends Cubit<ContactStoreState> {
  final UserBusiness _userBusiness;

  ContactStore({UserBusiness? userBusiness})
    : _userBusiness = userBusiness ?? getIt<UserBusiness>(),
      super(const ContactStoreState());

  /**
   * @description: 初始化，从数据库加载所有用户基础数据
   */
  Future<void> init() async {
    try {
      final users = await _userBusiness.getAllUsers();
      final Map<String, UserInfo> newUserMap = {};
      for (var user in users) {
        newUserMap[user.userId] = user;
      }
      emit(state.copyWith(userMap: newUserMap, version: state.version + 1));
      print('ContactStore: 初始化完成，用户总数: ${newUserMap.length}');
    } catch (e) {
      print('ContactStore: 初始化失败: $e');
      rethrow;
    }
  }

  /**
   * @description: 更新或添加单个联系人信息
   */
  void updateContact(
    String userId,
    UserInfo contactInfo, {
    bool force = false,
  }) {
    final existing = state.userMap[userId];
    bool updated = false;

    if (existing != null) {
      // 这里的逻辑可以根据版本号进一步优化，目前简单合并
      final newUser = UserInfo(
        userId: userId,
        nickname: contactInfo.nickname.isNotEmpty
            ? contactInfo.nickname
            : existing.nickname,
        avatar: (contactInfo.avatar?.isNotEmpty ?? false)
            ? contactInfo.avatar
            : existing.avatar,
        abstract: (contactInfo.abstract?.isNotEmpty ?? false)
            ? contactInfo.abstract
            : existing.abstract,
        email: (contactInfo.email?.isNotEmpty ?? false)
            ? contactInfo.email
            : existing.email,
        gender: contactInfo.gender != 0 ? contactInfo.gender : existing.gender,
      );

      if (newUser != existing || force) {
        final newMap = Map<String, UserInfo>.from(state.userMap);
        newMap[userId] = newUser;
        emit(state.copyWith(userMap: newMap, version: state.version + 1));
        updated = true;
      }
    } else {
      final newMap = Map<String, UserInfo>.from(state.userMap);
      newMap[userId] = contactInfo;
      emit(state.copyWith(userMap: newMap, version: state.version + 1));
      updated = true;
    }

    if (updated) {
      print('ContactStore: 更新用户 $userId 信息');
    }
  }

  /**
   * @description: 批量更新用户信息
   */
  Future<void> updateContactsByIds(List<String> userIds) async {
    if (userIds.isEmpty) return;
    try {
      final users = await _userBusiness.getUsersBasicInfo(userIds);
      for (var user in users) {
        updateContact(user.userId, user);
      }
    } catch (e) {
      print('ContactStore: 批量更新失败: $e');
    }
  }

  /// 获取单个用户信息 (Getter 对标)
  UserInfo? getContact(String userId) {
    return state.userMap[userId];
  }
}
