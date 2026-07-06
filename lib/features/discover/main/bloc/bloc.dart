import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/discover/main/bloc/event.dart';
import 'package:beaver/features/discover/main/bloc/state.dart';
import 'package:beaver/features/discover/main/data/repositories/repository.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverMainRepository _repository;

  DiscoverBloc(this._repository) : super(const DiscoverState()) {
    on<LoadDiscoverItemsEvent>(_onLoadDiscoverItems);
  }

  Future<void> _onLoadDiscoverItems(
    LoadDiscoverItemsEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.loading));

    final discoverItems = await _repository.getDiscoverItems();
    emit(state.copyWith(
      status: DiscoverStatus.success,
      discoverItems: discoverItems,
    ));
  }
}

