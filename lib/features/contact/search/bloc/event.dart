abstract class SearchFriendEvent {
  const SearchFriendEvent();
}

class UpdateSearchQueryEvent extends SearchFriendEvent {
  final String query;

  const UpdateSearchQueryEvent(this.query);
}

class PerformSearchEvent extends SearchFriendEvent {
  const PerformSearchEvent();
}

class ScanCodeEvent extends SearchFriendEvent {
  const ScanCodeEvent();
}

class GoToDetailEvent extends SearchFriendEvent {
  final String userId;

  const GoToDetailEvent(this.userId);
}

class SendFriendRequestEvent extends SearchFriendEvent {
  final String friendId;
  final String message;

  const SendFriendRequestEvent(this.friendId, this.message);
}
