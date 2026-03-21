import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/types/business/group.dart';

class GroupStoreState extends Equatable {
  final List<GroupInfo> groups;

  const GroupStoreState({
    this.groups = const [],
  });

  GroupStoreState copyWith({
    List<GroupInfo>? groups,
  }) {
    return GroupStoreState(
      groups: groups ?? this.groups,
    );
  }

  @override
  List<Object?> get props => [groups];
}

class GroupStore extends Cubit<GroupStoreState> {
  final GroupBusiness _groupBusiness;
  
  GroupStore({GroupBusiness? groupBusiness}) 
    : _groupBusiness = groupBusiness ?? getIt<GroupBusiness>(),
      super(const GroupStoreState());

  Future<void> init() async {
    try {
      final groups = await _groupBusiness.getGroupList();
      emit(state.copyWith(
        groups: groups ?? [],
      ));
    } catch (e) {
      print('GroupStore: 初始化失败: $e');
    }
  }
}
