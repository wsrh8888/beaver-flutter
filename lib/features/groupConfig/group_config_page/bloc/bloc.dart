import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/groupConfig/group_config_page/bloc/event.dart';
import 'package:beaver/features/groupConfig/group_config_page/bloc/state.dart';
import 'package:beaver/features/groupConfig/group_config_page/data/repositories/repository.dart';

class GroupConfigBloc extends Bloc<GroupConfigEvent, GroupConfigState> {
  final GroupConfigRepository _repository;
  String _currentUserId = '1';

  GroupConfigBloc(this._repository) : super(const GroupConfigState()) {
    on<LoadGroupInfoEvent>(_onLoadGroupInfo);
    on<OpenNameModalEvent>(_onOpenNameModal);
    on<CloseNameModalEvent>(_onCloseNameModal);
    on<UpdateGroupNameEvent>(_onUpdateGroupName);
    on<SaveGroupNameEvent>(_onSaveGroupName);
    on<NavigateToGroupMemberEvent>(_onNavigateToGroupMember);
    on<ExitGroupEvent>(_onExitGroup);
  }

  Future<void> _onLoadGroupInfo(
    LoadGroupInfoEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(
      status: GroupConfigStatus.loading,
      groupId: event.groupId,
    ));

    try {
      final groupInfo = await _repository.getGroupInfo(event.groupId);
      final groupMembers = await _repository.getGroupMembers(event.groupId);
      final currentUser = groupMembers.firstWhere(
        (member) => member.userId == _currentUserId,
        orElse: () => GroupMember(
          userId: '',
          nickname: '',
          fileName: '',
          role: 0,
        ),
      );
      final isAdmin = currentUser.role == 1 || currentUser.role == 2;

      emit(state.copyWith(
        status: GroupConfigStatus.success,
        groupInfo: groupInfo,
        groupMembers: groupMembers,
        isAdmin: isAdmin,
        groupName: groupInfo.title,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: '加载群组信息失败: $e',
      ));
    }
  }

  Future<void> _onOpenNameModal(
    OpenNameModalEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    if (!state.isAdmin) {
      emit(state.copyWith(
        errorMessage: '不是群聊管理员或群主，无法修改群名称',
      ));
      return;
    }
    emit(state.copyWith(
      showNameModal: true,
      groupName: state.groupInfo?.title ?? '',
    ));
  }

  Future<void> _onCloseNameModal(
    CloseNameModalEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(showNameModal: false));
  }

  Future<void> _onUpdateGroupName(
    UpdateGroupNameEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(groupName: event.name));
  }

  Future<void> _onSaveGroupName(
    SaveGroupNameEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    if (state.groupName.trim().isEmpty) {
      emit(state.copyWith(
        errorMessage: '群名称不能为空',
      ));
      return;
    }

    emit(state.copyWith(status: GroupConfigStatus.loading));

    try {
      await _repository.updateGroupName(state.groupId, state.groupName);
      final updatedGroupInfo = state.groupInfo?.copyWith(title: state.groupName);
      emit(state.copyWith(
        status: GroupConfigStatus.success,
        groupInfo: updatedGroupInfo,
        showNameModal: false,
        errorMessage: '群名称修改成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: '修改群名称失败: $e',
      ));
    }
  }

  Future<void> _onNavigateToGroupMember(
    NavigateToGroupMemberEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    // 导航到群成员页面
  }

  Future<void> _onExitGroup(
    ExitGroupEvent event,
    Emitter<GroupConfigState> emit,
  ) async {
    emit(state.copyWith(status: GroupConfigStatus.loading));

    try {
      await _repository.quitGroup(state.groupId);
      emit(state.copyWith(
        status: GroupConfigStatus.success,
        errorMessage: '已退出群聊',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupConfigStatus.error,
        errorMessage: '退出群聊失败: $e',
      ));
    }
  }
}
