import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/calls/history/bloc/event.dart';
import 'package:beaver/features/calls/history/bloc/state.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/di/injection.dart';

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  final _callBusiness = getIt<CallBusiness>();
  
  CallHistoryBloc() : super(const CallHistoryState()) {
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
      final callHistoryList = await _callBusiness.getCallHistory();
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
      await _callBusiness.deleteCallHistory(event.callId);
      final updatedList = state.callHistoryList.where((call) => call.id != event.callId).toList();
      emit(state.copyWith(callHistoryList: updatedList));
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
      await _callBusiness.clearCallHistory();
      emit(state.copyWith(callHistoryList: []));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '清空通话历史失败: $e',
      ));
    }
  }
}
