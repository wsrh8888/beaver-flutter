import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/group/notifications/bloc/event.dart';
import 'package:beaver/features/group/notifications/bloc/state.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/features/group/notifications/data/repositories/repository.dart';

class GroupNotificationsBloc extends Bloc<GroupNotificationsEvent, GroupNotificationsState> {
  final GroupNotificationRepository _repository = GroupNotificationRepository();

  GroupNotificationsBloc() : super(const GroupNotificationsState()) {
    on<LoadGroupNotificationsEvent>(_onLoadNotifications);
    on<SwitchTabEvent>(_onSwitchTab);
    on<AcceptGroupRequestEvent>(_onAcceptRequest);
    on<RejectGroupRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadNotifications(
    LoadGroupNotificationsEvent event,
    Emitter<GroupNotificationsState> emit,
  ) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    try {
      final notifications = await _repository.getGroupNotifications();
      emit(state.copyWith(
        status: GroupNotificationsStatus.success,
        notifications: notifications,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupNotificationsStatus.error,
        errorMessage: '加载群通知失败: $e',
      ));
    }
  }

  Future<void> _onSwitchTab(SwitchTabEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onAcceptRequest(AcceptGroupRequestEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    try {
      await _repository.updateRequestStatus(event.id, 1);
      final updated = state.notifications.map<GroupNotification>((n) {
        if (n.id == event.id) {
          return GroupNotification(
            id: n.id,
            groupId: n.groupId,
            groupName: n.groupName,
            groupAvatar: n.groupAvatar,
            applicantUserId: n.applicantUserId,
            applicantNickname: n.applicantNickname,
            applicantAvatar: n.applicantAvatar,
            message: n.message,
            status: 1,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      emit(state.copyWith(status: GroupNotificationsStatus.success, notifications: updated));
    } catch (e) {
      emit(state.copyWith(status: GroupNotificationsStatus.error, errorMessage: '处理失败: $e'));
    }
  }

  Future<void> _onRejectRequest(RejectGroupRequestEvent event, Emitter<GroupNotificationsState> emit) async {
    emit(state.copyWith(status: GroupNotificationsStatus.loading));
    try {
      await _repository.updateRequestStatus(event.id, 2);
      final updated = state.notifications.map<GroupNotification>((n) {
        if (n.id == event.id) {
          return GroupNotification(
            id: n.id,
            groupId: n.groupId,
            groupName: n.groupName,
            groupAvatar: n.groupAvatar,
            applicantUserId: n.applicantUserId,
            applicantNickname: n.applicantNickname,
            applicantAvatar: n.applicantAvatar,
            message: n.message,
            status: 2,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      emit(state.copyWith(status: GroupNotificationsStatus.success, notifications: updated));
    } catch (e) {
      emit(state.copyWith(status: GroupNotificationsStatus.error, errorMessage: '处理失败: $e'));
    }
  }
}
