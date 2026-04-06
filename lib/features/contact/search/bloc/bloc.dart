import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';

class SearchContactBloc extends Bloc<SearchContactEvent, SearchContactState> {
  final SearchContactRepository _repository;

  SearchContactBloc(this._repository) : super(const SearchContactState()) {
    on<SearchUserEvent>(_onSearchUser);
    on<AddFriendEvent>(_onAddFriend);
  }

  Future<void> _onSearchUser(
    SearchUserEvent event,
    Emitter<SearchContactState> emit,
  ) async {
    emit(state.copyWith(status: SearchContactStatus.loading));
    try {
      final user = await _repository.searchUser(event.query);
      if (user != null) {
        emit(state.copyWith(status: SearchContactStatus.success, user: user));
      } else {
        emit(
          state.copyWith(
            status: SearchContactStatus.error,
            errorMessage: '未找到相关用户',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchContactStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddFriend(
    AddFriendEvent event,
    Emitter<SearchContactState> emit,
  ) async {
    try {
      final response = await _repository.addFriend(event.userId);
      if (response.code == 0) {
        emit(
          state.copyWith(
            status: SearchContactStatus.success,
            errorMessage: '好友请求发送成功',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SearchContactStatus.error,
            errorMessage: response.msg,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchContactStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
