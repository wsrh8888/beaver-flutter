import 'package:beaver/features/group/member/data/models/member.dart';

enum GroupMemberStatus { initial, loading, success, error }

class GroupMemberState {
  final GroupMemberStatus status;
  final String mode; // 'add', 'remove', 'view'
  final String groupId;
  final List<GroupMember> groupMembers;
  final List<Contact> contacts;
  final List<String> selectedIds;
  final String? errorMessage;

  const GroupMemberState({
    this.status = GroupMemberStatus.initial,
    this.mode = 'view',
    this.groupId = '',
    this.groupMembers = const [],
    this.contacts = const [],
    this.selectedIds = const [],
    this.errorMessage,
  });

  int get selectedCount => selectedIds.length;

  GroupMemberState copyWith({
    GroupMemberStatus? status,
    String? mode,
    String? groupId,
    List<GroupMember>? groupMembers,
    List<Contact>? contacts,
    List<String>? selectedIds,
    String? errorMessage,
  }) {
    return GroupMemberState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      groupId: groupId ?? this.groupId,
      groupMembers: groupMembers ?? this.groupMembers,
      contacts: contacts ?? this.contacts,
      selectedIds: selectedIds ?? this.selectedIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

