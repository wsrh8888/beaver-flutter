import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/group.dart';

enum GroupNotificationsStatus { initial, loading, success, error }

class GroupNotificationsState extends Equatable {
  final GroupNotificationsStatus status;
  final List<GroupNotification> notifications;
  final String? errorMessage;
  final String activeTab; // 'received' or 'sent'

  const GroupNotificationsState({
    this.status = GroupNotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.activeTab = 'received',
  });

  GroupNotificationsState copyWith({
    GroupNotificationsStatus? status,
    List<GroupNotification>? notifications,
    String? errorMessage,
    String? activeTab,
  }) {
    return GroupNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage, activeTab];
}
