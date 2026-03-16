import 'package:beaver/features/searchFriend/search_friend_page/data/models/search.dart';

enum SearchFriendStatus { initial, loading, success, error }

class SearchFriendState {
  final SearchFriendStatus status;
  final String searchQuery;
  final SearchResult? searchResult;
  final bool showResult;
  final String? errorMessage;

  const SearchFriendState({
    this.status = SearchFriendStatus.initial,
    this.searchQuery = '',
    this.searchResult,
    this.showResult = false,
    this.errorMessage,
  });

  SearchFriendState copyWith({
    SearchFriendStatus? status,
    String? searchQuery,
    SearchResult? searchResult,
    bool? showResult,
    String? errorMessage,
  }) {
    return SearchFriendState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      showResult: showResult ?? this.showResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
