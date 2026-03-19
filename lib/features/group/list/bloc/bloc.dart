import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/group/list/bloc/event.dart';
import 'package:beaver/features/group/list/bloc/state.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/di/injection.dart';

class GroupListBloc extends Bloc<GroupListEvent, GroupListState> {
  final _groupBusiness = getIt<GroupBusiness>();

  GroupListBloc() : super(const GroupListState()) {
    on<LoadGroupListEvent>(_onLoadGroupList);
    on<SelectGroupEvent>(_onSelectGroup);
    on<CreateGroupEvent>(_onCreateGroup);
  }

  Future<void> _onLoadGroupList(
    LoadGroupListEvent event,
    Emitter<GroupListState> emit,
  ) async {
    emit(state.copyWith(status: GroupListStatus.loading));

    try {
      final groupList = await _groupBusiness.getGroupList();
      emit(state.copyWith(
        status: GroupListStatus.success,
        groupList: groupList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupListStatus.error,
        errorMessage: '加载群聊列表失败: $e',
      ));
    }
  }

  Future<void> _onSelectGroup(
    SelectGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    // 导航到群聊页?
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupListState> emit,
  ) async {
    // 导航到创建群聊页?
  }
}

