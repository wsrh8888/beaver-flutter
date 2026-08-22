import 'package:beaver/api/file.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/core/datasync/circle/circle_sync.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/circle/list/bloc/event.dart';
import 'package:beaver/features/circle/list/bloc/state.dart';
import 'package:beaver/features/circle/list/data/repositories/repository.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CircleListBloc extends Bloc<CircleListEvent, CircleListState> {
  final CircleListRepository _repository;
  final CircleStore _circleStore;
  final CircleBusiness _circleBusiness;

  CircleListBloc(
    this._repository, {
    CircleStore? circleStore,
    CircleBusiness? circleBusiness,
  })  : _circleStore = circleStore ?? getIt<CircleStore>(),
        _circleBusiness = circleBusiness ?? getIt<CircleBusiness>(),
        super(const CircleListState()) {
    on<LoadCircleListEvent>(_onLoad);
    on<CreateCircleEvent>(_onCreate);
  }

  List<ICircleListItem> _mapLocal() {
    return _circleStore.state.circleList
        .map(
          (c) => ICircleListItem(
            circleId: c.circleId,
            name: c.name,
            avatar: c.avatar.isNotEmpty ? c.avatar : null,
            description: c.description.isNotEmpty ? c.description : null,
            memberCount: c.memberCount,
            joinType: c.joinType,
            role: c.role,
          ),
        )
        .toList();
  }

  Future<void> _onLoad(
    LoadCircleListEvent event,
    Emitter<CircleListState> emit,
  ) async {
    // 先出本地，再增量同步校准
    final local = _mapLocal();
    emit(state.copyWith(
      status: local.isEmpty ? CircleListStatus.loading : CircleListStatus.success,
      circles: local,
    ));

    await circleSync.checkAndSync();
    await _circleStore.init();

    emit(state.copyWith(
      status: CircleListStatus.success,
      circles: _mapLocal(),
    ));
  }

  Future<void> _onCreate(
    CreateCircleEvent event,
    Emitter<CircleListState> emit,
  ) async {
    emit(state.copyWith(
      status: CircleListStatus.creating,
      errorMessage: null,
    ));

    String? avatarUrl;
    if (event.avatarPath != null && event.avatarPath!.isNotEmpty) {
      final uploadRes = await uploadFileApi(event.avatarPath!);
      if (uploadRes.code != 0 || uploadRes.result == null) {
        emit(state.copyWith(
          status: CircleListStatus.error,
          errorMessage: uploadRes.msg.isNotEmpty ? uploadRes.msg : '头像上传失败',
        ));
        return;
      }
      avatarUrl = uploadRes.result!.fileUrl;
    }

    final res = await _repository.createCircle(
      name: event.name,
      avatar: avatarUrl,
    );
    if (res.code != 0 || res.result == null) {
      emit(state.copyWith(
        status: CircleListStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '创建圈子失败',
      ));
      return;
    }

    await _circleBusiness.upsertAfterCreate(
      circleId: res.result!.circleId,
      name: res.result!.name.isNotEmpty ? res.result!.name : event.name,
      avatar: avatarUrl ?? '',
    );
    await _circleStore.updateCirclesByIds([res.result!.circleId]);

    emit(state.copyWith(
      status: CircleListStatus.success,
      circles: _mapLocal(),
      errorMessage: null,
    ));
  }
}
