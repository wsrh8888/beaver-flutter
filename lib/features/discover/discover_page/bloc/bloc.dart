import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/discover/discover_page/bloc/event.dart';
import 'package:beaver/features/discover/discover_page/bloc/state.dart';
import 'package:beaver/features/discover/discover_page/data/repositories/repository.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository _repository;

  DiscoverBloc(this._repository) : super(const DiscoverState()) {
    on<LoadDiscoverItemsEvent>(_onLoadDiscoverItems);
    on<NavigateToEvent>(_onNavigateTo);
  }

  Future<void> _onLoadDiscoverItems(
    LoadDiscoverItemsEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.loading));

    try {
      final discoverItems = await _repository.getDiscoverItems();
      emit(state.copyWith(
        status: DiscoverStatus.success,
        discoverItems: discoverItems,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.error,
        errorMessage: '加载发现项目失败: $e',
      ));
    }
  }

  Future<void> _onNavigateTo(
    NavigateToEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    // 导航逻辑
  }
}
