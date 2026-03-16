import 'package:beaver/features/groupList/group_list_page/data/models/group.dart';

enum GroupListStatus { initial, loading, success, error }

class GroupListState {
  final GroupListStatus status;
  final List<GroupInfo> groupList;
  final String? errorMessage;

  const GroupListState({
    this.status = GroupListStatus.initial,
    this.groupList = const [],
    this.errorMessage,
  });

  GroupListState copyWith({
    GroupListStatus? status,
    List<GroupInfo>? groupList,
    String? errorMessage,
  }) {
    return GroupListState(
      status: status ?? this.status,
      groupList: groupList ?? this.groupList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
