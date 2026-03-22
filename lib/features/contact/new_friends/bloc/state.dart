import 'package:beaver/types/business/contact.dart';

enum NewFriendsStatus { initial, loading, success, error }

class NewFriendsState {
  final NewFriendsStatus status;
  final List<FriendRequest> friendRequests;
  final String activeTab;
  final String? errorMessage;

  const NewFriendsState({
    this.status = NewFriendsStatus.initial,
    this.friendRequests = const [],
    this.activeTab = 'received',
    this.errorMessage,
  });

  NewFriendsState copyWith({
    NewFriendsStatus? status,
    List<FriendRequest>? friendRequests,
    String? activeTab,
    String? errorMessage,
  }) {
    return NewFriendsState(
      status: status ?? this.status,
      friendRequests: friendRequests ?? this.friendRequests,
      activeTab: activeTab ?? this.activeTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

