import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group_member.dart';
import 'package:beaver/types/business/group.dart';

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

  GroupMemberStore({GroupMemberBusiness? groupMemberBusiness})
    : _groupMemberBusiness = groupMemberBusiness ?? getIt<GroupMemberBusiness>(),
      super(const GroupMemberStoreState());

  Future<void> init(String groupId) async {
    try {
      if (state.memberMap.containsKey(groupId)) {
        return;
      }
      final members = await _groupMemberBusiness.getGroupMembers(groupId);
      final newMap = Map<String, List<GroupMember>>.from(state.memberMap);
      newMap[groupId] = members;
      emit(state.copyWith(
        memberMap: newMap,
        version: state.version + 1,
      ));
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
    final existing = state.memberMap[groupId] ?? [];
    final newMap = Map<String, List<GroupMember>>.from(state.memberMap);
    newMap[groupId] = [...existing, ...members];
    emit(state.copyWith(
      memberMap: newMap,
      version: state.version + 1,
    ));
  }

  void removeMembers(String groupId, List<String> memberIds) {
    final existing = state.memberMap[groupId] ?? [];
    final newMap = Map<String, List<GroupMember>>.from(state.memberMap);
    newMap[groupId] = existing.where((member) => !memberIds.contains(member.userId)).toList();
    emit(state.copyWith(
      memberMap: newMap,
      version: state.version + 1,
    ));
  }

  Future<void> updateMembersByGroupIds(List<String> groupIds) async {
    if (groupIds.isEmpty) return;
    try {
      final newMap = Map<String, List<GroupMember>>.from(state.memberMap);
      for (final groupId in groupIds) {
        final members = await _groupMemberBusiness.getGroupMembers(groupId);
        newMap[groupId] = members;
      }
      emit(state.copyWith(
        memberMap: newMap,
        version: state.version + 1,
      ));
    } catch (e) {
      print('GroupMemberStore: 批量更新失败: $e');
    }
  }

  void reset() {
    emit(const GroupMemberStoreState());
  }
}
