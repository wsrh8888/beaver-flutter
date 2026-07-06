import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/circle/list/bloc/event.dart';
import 'package:beaver/features/circle/list/bloc/state.dart';
import 'package:beaver/features/circle/list/data/repositories/repository.dart';

class CircleListBloc extends Bloc<CircleListEvent, CircleListState> {
  final CircleListRepository _repository;

  CircleListBloc(this._repository) : super(const CircleListState()) {
    on<LoadCircleListEvent>(_onLoad);
    on<CreateCircleEvent>(_onCreate);
  }

  Future<void> _onLoad(
    LoadCircleListEvent event,
    Emitter<CircleListState> emit,
  ) async {
    emit(state.copyWith(status: CircleListStatus.loading));

    final res = await _repository.loadMyCircles();
    if (res.code != 0) {
      emit(state.copyWith(
        status: CircleListStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '获取圈子列表失败',
      ));
      return;
    }

    emit(state.copyWith(
      status: CircleListStatus.success,
      circles: res.result?.list ?? [],
    ));
  }

  Future<void> _onCreate(
    CreateCircleEvent event,
    Emitter<CircleListState> emit,
  ) async {
    final res = await _repository.createCircle(
      name: event.name,
      description: event.description,
    );
    if (res.code != 0) {
      emit(state.copyWith(
        status: CircleListStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '创建圈子失败',
      ));
      return;
    }

    add(const LoadCircleListEvent());
  }
}
