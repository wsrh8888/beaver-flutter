import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/groupMember/group_member_page/bloc/event.dart';
import 'package:beaver/features/groupMember/group_member_page/bloc/state.dart';
import 'package:beaver/features/groupMember/group_member_page/data/repositories/repository.dart';

class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  final GroupMemberRepository _repository;
  String _currentUserId = '1';

  GroupMemberBloc(this._repository) : super(const GroupMemberState()) {
    on<LoadGroupMembersEvent>(_onLoadGroupMembers);
    on<ToggleSelectEvent>(_onToggleSelect);
    on<ConfirmAddEvent>(_onConfirmAdd);
    on<ConfirmRemoveEvent>(_onConfirmRemove);
  }

  Future<void> _onLoadGroupMembers(
    LoadGroupMembersEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    emit(state.copyWith(
      status: GroupMemberStatus.loading,
      groupId: event.groupId,
      mode: event.mode,
    ));

    try {
      final groupMembers = await _repository.getGroupMembers(event.groupId);
      final contacts = await _repository.getContacts();
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        groupMembers: groupMembers,
        contacts: contacts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '加载群成员失败: $e',
      ));
    }
  }

  Future<void> _onToggleSelect(
    ToggleSelectEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    final updatedSelectedIds = List<String>.from(state.selectedIds);
    if (updatedSelectedIds.contains(event.userId)) {
      updatedSelectedIds.remove(event.userId);
    } else {
      updatedSelectedIds.add(event.userId);
    }
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  Future<void> _onConfirmAdd(
    ConfirmAddEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    if (state.selectedIds.isEmpty) {
      emit(state.copyWith(
        errorMessage: '请选择要添加的成员',
      ));
      return;
    }

    emit(state.copyWith(status: GroupMemberStatus.loading));

    try {
      await _repository.addGroupMembers(state.groupId, state.selectedIds);
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        selectedIds: [],
        errorMessage: '添加成员成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '添加成员失败: $e',
      ));
    }
  }

  Future<void> _onConfirmRemove(
    ConfirmRemoveEvent event,
    Emitter<GroupMemberState> emit,
  ) async {
    if (state.selectedIds.isEmpty) {
      emit(state.copyWith(
        errorMessage: '请选择要移除的成员',
      ));
      return;
    }

    emit(state.copyWith(status: GroupMemberStatus.loading));

    try {
      await _repository.removeGroupMembers(state.groupId, state.selectedIds);
      emit(state.copyWith(
        status: GroupMemberStatus.success,
        selectedIds: [],
        errorMessage: '移除成员成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupMemberStatus.error,
        errorMessage: '移除成员失败: $e',
      ));
    }
  }
}
