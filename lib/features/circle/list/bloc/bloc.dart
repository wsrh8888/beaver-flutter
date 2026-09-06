/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:beaver/api/file.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/core/datasync/circle/circle_sync.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/circle/list/bloc/event.dart';
import 'package:beaver/features/circle/list/bloc/state.dart';
import 'package:beaver/features/circle/list/data/repositories/repository.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('circle-list');

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

    _logger.info({'text': '加载圈子列表', 'data': {'localCount': local.length}});

    try {
      await circleSync.checkAndSync();
      await _circleStore.init();
    } catch (e) {
      _logger.warn({
        'text': '圈子列表同步失败，回退本地数据',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        status: CircleListStatus.success,
        circles: _mapLocal(),
      ));
      return;
    }

    final synced = _mapLocal();
    _logger.info({'text': '圈子列表加载成功', 'data': {'count': synced.length}});
    emit(state.copyWith(
      status: CircleListStatus.success,
      circles: synced,
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

    _logger.info({
      'text': '创建圈子',
      'data': {
        'name': event.name,
        'hasAvatar': event.avatarPath != null && event.avatarPath!.isNotEmpty,
      },
    });

    String? avatarUrl;
    if (event.avatarPath != null && event.avatarPath!.isNotEmpty) {
      final uploadRes = await uploadFileApi(event.avatarPath!);
      if (uploadRes.code != 0 || uploadRes.result == null) {
        _logger.warn({
          'text': '圈子头像上传失败',
          'data': {'code': uploadRes.code, 'msg': uploadRes.msg},
        });
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
      _logger.warn({
        'text': '创建圈子失败',
        'data': {'code': res.code, 'msg': res.msg},
      });
      emit(state.copyWith(
        status: CircleListStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '创建圈子失败',
      ));
      return;
    }

    _logger.info({
      'text': '创建圈子成功',
      'data': {'circleId': res.result!.circleId, 'name': res.result!.name},
    });

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
