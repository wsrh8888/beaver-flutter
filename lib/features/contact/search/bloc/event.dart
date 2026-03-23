abstract class SearchContactEvent {
  const SearchContactEvent();
}

class SearchUserEvent extends SearchContactEvent {
  final String query;
  const SearchUserEvent(this.query);
}

class AddFriendEvent extends SearchContactEvent {
  final String userId;
  const AddFriendEvent(this.userId);
}
