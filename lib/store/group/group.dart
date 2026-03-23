import 'dart:async';

import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupStoreState extends Equatable {
  final Map<String, GroupInfo> groupMap;
  final int version;

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
  Timer? _groupUpdateDebounceTimer;
  final Set<String> _pendingGroupIds = <String>{};

  GroupStore({GroupBusiness? groupBusiness})
      : _groupBusiness = groupBusiness ?? getIt<GroupBusiness>(),
        super(const GroupStoreState()) {
    _groupBusinessSubscription = _groupBusiness.groupUpdateStream.listen((ids) {
      _pendingGroupIds.addAll(ids.where((id) => id.trim().isNotEmpty));
      _groupUpdateDebounceTimer?.cancel();
      _groupUpdateDebounceTimer = Timer(const Duration(milliseconds: 200), () {
        final pending = _pendingGroupIds.toList(growable: false);
        _pendingGroupIds.clear();
        updateGroupsByIds(pending);
      });
    });
  }

  @override
  Future<void> close() {
    _groupBusinessSubscription?.cancel();
    _groupUpdateDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> init() async {
    try {
      final groups = await _groupBusiness.getGroupList();
      final nextMap = <String, GroupInfo>{};
      if (groups != null) {
        for (final group in groups) {
          nextMap[group.conversationId] = group;
        }
      }
      emit(state.copyWith(groupMap: nextMap, version: state.version + 1));
    } catch (e) {
      print('GroupStore: init failed: $e');
    }
  }

  Future<void> updateGroupsByIds(List<String> groupIds) async {
    if (groupIds.isEmpty) return;
    try {
      final groups = await _groupBusiness.getGroupsByIds(groupIds);
      if (groups == null || groups.isEmpty) return;

      final nextMap = Map<String, GroupInfo>.from(state.groupMap);
      var changed = false;
      for (final group in groups) {
        final key = group.conversationId;
        final existing = nextMap[key];
        if (existing != group) {
          nextMap[key] = group;
          changed = true;
        }
      }

      if (changed) {
        emit(state.copyWith(groupMap: nextMap, version: state.version + 1));
      }
    } catch (e) {
      print('GroupStore: updateGroupsByIds failed: $e');
    }
  }

  GroupInfo? getGroup(String groupId) {
    return state.groupMap[groupId];
  }
}
