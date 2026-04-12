import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/store/contact/contact.dart';

class GroupMemberStoreState extends Equatable {
  final Map<String, List<GroupMember>> memberMap;
  final int version;

  const GroupMemberStoreState({
    this.memberMap = const {},
    this.version = 0,
  });

  GroupMemberStoreState copyWith({
    Map<String, List<GroupMember>>? memberMap,
    int? version,
  }) {
    return GroupMemberStoreState(
      memberMap: memberMap ?? this.memberMap,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [memberMap, version];
}

class GroupMemberStore extends Cubit<GroupMemberStoreState> {
  final GroupMemberBusiness _groupMemberBusiness;
  final ContactStore _contactStore;
  StreamSubscription? _contactSubscription;

  // 原始群成员记录 (对标 FriendStore _rawFriends)
  final Map<String, List<GroupMember>> _rawMemberMap = {};

  GroupMemberStore({
    GroupMemberBusiness? groupMemberBusiness,
    ContactStore? contactStore,
  }) : _groupMemberBusiness =
           groupMemberBusiness ?? getIt<GroupMemberBusiness>(),
       _contactStore = contactStore ?? getIt<ContactStore>(),
       super(const GroupMemberStoreState()) {
    // 监听全局联系人变更，重组数据更新头像/昵称 (对标 FriendStore)
    _contactSubscription = _contactStore.stream.listen((_) {
      if (_rawMemberMap.isNotEmpty) {
        _reassemble();
      }
    });
  }

  @override
  Future<void> close() {
    _contactSubscription?.cancel();
    return super.close();
  }

  /**
   * @description: 数据重组逻辑 (Identity Resolution)
   * 将业务原始数据 (_rawMemberMap) 与 ContactStore 里的全局最新头像/昵称进行聚合
   */
  void _reassemble() {
    final userMap = _contactStore.state.userMap;
    final nextMap = <String, List<GroupMember>>{};

    _rawMemberMap.forEach((groupId, members) {
      nextMap[groupId] = members.map((member) {
        final userInfo = userMap[member.userId];
        return member.copyWith(
          nickname: userInfo?.nickname.isNotEmpty == true
              ? userInfo!.nickname
              : member.nickname,
          avatar: userInfo?.avatar ?? member.avatar,
        );
      }).toList();
    });

    emit(state.copyWith(memberMap: nextMap, version: state.version + 1));
  }

  Future<void> init(String groupId) async {
    try {
      if (_rawMemberMap.containsKey(groupId)) {
        return;
      }
      final members = await _groupMemberBusiness.getGroupMembers(groupId);
      _rawMemberMap[groupId] = members;
      _reassemble();
    } catch (e) {
      print('GroupMemberStore: 初始化失败: $e');
    }
  }

  List<GroupMember> getMembersByGroupId(String groupId) {
    return state.memberMap[groupId] ?? [];
  }

  GroupMember? getMemberByUserId(String userId) {
    for (final members in state.memberMap.values) {
      for (final member in members) {
        if (member.userId == userId) {
          return member;
        }
      }
    }
    return null;
  }

  void addMembers(String groupId, List<GroupMember> members) {
    final existing = _rawMemberMap[groupId] ?? [];
    _rawMemberMap[groupId] = [...existing, ...members];
    _reassemble();
  }

  void removeMembers(String groupId, List<String> memberIds) {
    final existing = _rawMemberMap[groupId] ?? [];
    _rawMemberMap[groupId] =
        existing.where((m) => !memberIds.contains(m.userId)).toList();
    _reassemble();
  }

  Future<void> updateMembersByGroupIds(List<String> groupIds) async {
    if (groupIds.isEmpty) return;
    try {
      for (final groupId in groupIds) {
        final members = await _groupMemberBusiness.getGroupMembers(groupId);
        _rawMemberMap[groupId] = members;
      }
      _reassemble();
    } catch (e) {
      print('GroupMemberStore: 批量更新失败: $e');
    }
  }

  void reset() {
    _rawMemberMap.clear();
    emit(const GroupMemberStoreState());
  }
}

