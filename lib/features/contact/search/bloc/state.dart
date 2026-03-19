import 'package:beaver/types/business/user.dart';

enum SearchContactStatus { initial, loading, success, error }

class SearchContactState {
  final SearchContactStatus status;
  final String searchQuery;
  final UserInfo? user;
  final bool showResult;
  final String? errorMessage;

  const SearchContactState({
    this.status = SearchContactStatus.initial,
    this.searchQuery = '',
    this.user,
    this.showResult = false,
    this.errorMessage,
  });

  SearchContactState copyWith({
    SearchContactStatus? status,
    String? searchQuery,
    UserInfo? user,
    bool? showResult,
    String? errorMessage,
  }) {
    return SearchContactState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      user: user ?? this.user,
      showResult: showResult ?? this.showResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

