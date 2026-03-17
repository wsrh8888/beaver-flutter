import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/group/config/bloc/event.dart';
import 'package:beaver/features/group/config/bloc/state.dart';
import 'package:beaver/features/group/config/data/repositories/repository.dart';

class GroupConfigBloc extends Bloc<GroupConfigEvent, GroupConfigState> {
  final GroupConfigRepository _repository;

  GroupConfigBloc(this._repository) : super(const GroupConfigState()) {
    on<LoadGroupInfoEvent>(_onLoadGroupInfo);
    on<UpdateGroupNameEvent>(_onUpdateGroupName);
    on<ExitGroupEvent>(_onExitGroup);
  }

  Future<void> _onLoadGroupInfo(
    LoadGroupInfoEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(status: GroupConfigStatus.loading));
    try {
      final info = await _repository.getGroupInfo(event.groupId);
      final members = await _repository.getGroupMembers(event.groupId);
      emit(state.copyWith(
        status: GroupConfigStatus.success,
        groupInfo: info,
        groupName: info.title,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateGroupName(
    UpdateGroupNameEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    if (state.groupName.isEmpty) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: '群名称不能为空',
      ));
      return;
    }

    try {
      final success = await _repository.updateGroupName(
        state.groupInfo!.groupId,
        state.groupName,
      );
      if (success) {
        emit(state.copyWith(
          status: GroupConfigStatus.success,
          errorMessage: '群名称修改成功',
        ));
      } else {
        emit(state.copyWith(
          status: GroupConfigStatus.error,
          errorMessage: '修改失败',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onExitGroup(
    ExitGroupEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    try {
      final success = await _repository.quitGroup(state.groupInfo!.groupId);
      if (success) {
        emit(state.copyWith(
          status: GroupConfigStatus.success,
          errorMessage: '已退出群聊',
        ));
      } else {
        emit(state.copyWith(
          status: GroupConfigStatus.error,
          errorMessage: '退出失败',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
