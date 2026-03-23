import 'package:beaver/features/group/config/data/models/config.dart';

enum GroupConfigStatus { initial, loading, success, error }

class GroupConfigState {
  final GroupConfigStatus status;
  final String groupId;
  final GroupInfo? groupInfo;
  final List<GroupMember> groupMembers;
  final bool isAdmin;
  final bool showNameModal;
  final String groupName;
  final String? errorMessage;

  const GroupConfigState({
    this.status = GroupConfigStatus.initial,
    this.groupId = '',
    this.groupInfo,
    this.groupMembers = const [],
    this.isAdmin = false,
    this.showNameModal = false,
    this.groupName = '',
    this.errorMessage,
  });

  GroupConfigState copyWith({
    GroupConfigStatus? status,
    String? groupId,
    GroupInfo? groupInfo,
    List<GroupMember>? groupMembers,
    bool? isAdmin,
    bool? showNameModal,
    String? groupName,
    String? errorMessage,
  }) {
    return GroupConfigState(
      status: status ?? this.status,
      groupId: groupId ?? this.groupId,
      groupInfo: groupInfo ?? this.groupInfo,
      groupMembers: groupMembers ?? this.groupMembers,
      isAdmin: isAdmin ?? this.isAdmin,
      showNameModal: showNameModal ?? this.showNameModal,
      groupName: groupName ?? this.groupName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

