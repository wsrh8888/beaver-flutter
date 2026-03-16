import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';

class SearchFriendBloc extends Bloc<SearchFriendEvent, SearchFriendState> {
  final SearchFriendRepository _repository;

  SearchFriendBloc(this._repository) : super(const SearchFriendState()) {
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
    on<PerformSearchEvent>(_onPerformSearch);
    on<ScanCodeEvent>(_onScanCode);
    on<GoToDetailEvent>(_onGoToDetail);
    on<SendFriendRequestEvent>(_onSendFriendRequest);
  }

  Future<void> _onUpdateSearchQuery(
    UpdateSearchQueryEvent event,
    Emitter<SearchFriendState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchFriendState> emit,
  ) async {
    if (state.searchQuery.isEmpty) {
      emit(state.copyWith(
        status: SearchFriendStatus.error,
        errorMessage: '请输入邮箱地址',
      ));
      return;
    }

    // 邮箱格式验证
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(state.searchQuery)) {
      emit(state.copyWith(
        status: SearchFriendStatus.error,
        errorMessage: '请输入正确的邮箱格式',
      ));
      return;
    }

    emit(state.copyWith(status: SearchFriendStatus.loading));

    try {
      final searchResult = await _repository.searchUser(state.searchQuery);
      if (searchResult != null) {
        emit(state.copyWith(
          status: SearchFriendStatus.success,
          searchResult: searchResult,
          showResult: true,
        ));
      } else {
        emit(state.copyWith(
          status: SearchFriendStatus.error,
          errorMessage: '未找到相关用�?,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SearchFriendStatus.error,
        errorMessage: '搜索失败，请稍后再试',
      ));
    }
  }

  Future<void> _onScanCode(
    ScanCodeEvent event,
    Emitter<SearchFriendState> emit,
  ) async {
    // 模拟扫码
    emit(state.copyWith(
      status: SearchFriendStatus.success,
      errorMessage: '打开相机扫描',
    ));
  }

  Future<void> _onGoToDetail(
    GoToDetailEvent event,
    Emitter<SearchFriendState> emit,
  ) async {
    // 导航到用户详情页
  }

  Future<void> _onSendFriendRequest(
    SendFriendRequestEvent event,
    Emitter<SearchFriendState> emit,
  ) async {
    emit(state.copyWith(status: SearchFriendStatus.loading));

    try {
      await _repository.sendFriendRequest(event.friendId, event.message, 'email');
      emit(state.copyWith(
        status: SearchFriendStatus.success,
        showResult: false,
        searchQuery: '',
        searchResult: null,
        errorMessage: '好友请求发送成�?,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchFriendStatus.error,
        errorMessage: '发送失败，请稍后再�?,
      ));
    }
  }
}

