import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/history/bloc/event.dart';
import 'package:beaver/features/calls/history/bloc/state.dart';
import 'package:beaver/features/calls/history/data/repositories/repository.dart';

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  final CallHistoryRepository _callHistoryRepository;
  
  CallHistoryBloc({CallHistoryRepository? callHistoryRepository}) 
    : _callHistoryRepository = callHistoryRepository ?? CallHistoryRepository(),
      super(const CallHistoryState()) {
    on<LoadCallHistoryEvent>(_onLoadCallHistory);
    on<DeleteCallHistoryEvent>(_onDeleteCallHistory);
    on<ClearCallHistoryEvent>(_onClearCallHistory);
  }
  
  Future<void> _onLoadCallHistory(
    LoadCallHistoryEvent event,
    Emitter<CallHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final callHistoryList = await _callHistoryRepository.getCallHistory();
      emit(state.copyWith(
        isLoading: false,
        callHistoryList: callHistoryList,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '加载通话历史失败: $e',
      ));
    }
  }
  
  Future<void> _onDeleteCallHistory(
    DeleteCallHistoryEvent event,
    Emitter<CallHistoryState> emit,
  ) async {
    try {
      final success = await _callHistoryRepository.deleteCallHistory(event.callId);
      if (success) {
        final updatedList = state.callHistoryList.where((call) => call.id != event.callId).toList();
        emit(state.copyWith(callHistoryList: updatedList));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '删除通话历史失败: $e',
      ));
    }
  }
  
  Future<void> _onClearCallHistory(
    ClearCallHistoryEvent event,
    Emitter<CallHistoryState> emit,
  ) async {
    try {
      final success = await _callHistoryRepository.clearCallHistory();
      if (success) {
        emit(state.copyWith(callHistoryList: []));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '清空通话历史失败: $e',
      ));
    }
  }
}
