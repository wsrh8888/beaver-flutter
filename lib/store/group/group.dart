import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/types/business/group.dart';

class GroupStoreState extends Equatable {
  final Map<String, GroupInfo> groupMap;
  final int version; // 用于触发响应式更新

  const GroupStoreState({
    this.groupMap = const {},
    this.version = 0,
  });

  GroupStoreState copyWith({
    Map<String, GroupInfo>? groupMap,
    int? version,
  }) {
    return GroupStoreState(
      groupMap: groupMap ?? this.groupMap,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [groupMap, version];
}

class GroupStore extends Cubit<GroupStoreState> {
  final GroupBusiness _groupBusiness;
  StreamSubscription? _groupBusinessSubscription;
  
  GroupStore({GroupBusiness? groupBusiness}) 
    : _groupBusiness = groupBusiness ?? getIt<GroupBusiness>(),
      super(const GroupStoreState()) {
    // 监听业务层流，实现响应式同步 (对标 PC 的 Main-to-Render 通知)
    _groupBusinessSubscription = _groupBusiness.groupUpdateStream.listen((groupIds) {
      updateGroupsByIds(groupIds);
    });
  }

  @override
  Future<void> close() {
    _groupBusinessSubscription?.cancel();
    return super.close();
  }

  Future<void> init() async {
    try {
      final groups = await _groupBusiness.getGroupList();
      final Map<String, GroupInfo> newGroupMap = {};
      if (groups != null) {
        for (var group in groups) {
          newGroupMap[group.conversationId] = group;
        }
      }
      emit(state.copyWith(
        groupMap: newGroupMap,
        version: state.version + 1,
      ));
    } catch (e) {
      print('GroupStore: 初始化失败: $e');
    }
  }

  /**
   * @description: 更新或添加单个群组信息
   */
  void updateGroup(String groupId, GroupInfo groupInfo) {
    final newMap = Map<String, GroupInfo>.from(state.groupMap);
    newMap[groupId] = groupInfo;
    emit(state.copyWith(groupMap: newMap, version: state.version + 1));
    print('GroupStore: 更新群组 $groupId 信息');
  }

  /**
   * @description: 批量更新群组信息
   */
  Future<void> updateGroupsByIds(List<String> groupIds) async {
    if (groupIds.isEmpty) return;
    try {
      // 从业务层获取最新详细信息
      final groups = await _groupBusiness.getGroupsByIds(groupIds);
      if (groups != null) {
        for (var group in groups) {
          updateGroup(group.conversationId, group);
        }
      }
    } catch (e) {
      print('GroupStore: 批量更新失败: $e');
    }
  }

  /// 获取单个群组信息 (Getter 对标)
  GroupInfo? getGroup(String groupId) {
    return state.groupMap[groupId];
  }
}
