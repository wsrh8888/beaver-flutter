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

import 'dart:async';

import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/circle.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('circle');

class CircleStoreState extends Equatable {
  final Map<String, CircleInfo> circleMap;
  final int version;

  const CircleStoreState({
    this.circleMap = const {},
    this.version = 0,
  });

  CircleStoreState copyWith({
    Map<String, CircleInfo>? circleMap,
    int? version,
  }) {
    return CircleStoreState(
      circleMap: circleMap ?? this.circleMap,
      version: version ?? this.version,
    );
  }

  List<CircleInfo> get circleList => circleMap.values.toList();

  @override
  List<Object?> get props => [circleMap, version];
}

class CircleStore extends Cubit<CircleStoreState> {
  final CircleBusiness _circleBusiness;
  StreamSubscription? _subscription;
  Timer? _debounce;
  final Set<String> _pendingIds = <String>{};

  CircleStore({CircleBusiness? circleBusiness})
      : _circleBusiness = circleBusiness ?? getIt<CircleBusiness>(),
        super(const CircleStoreState()) {
    _subscription = _circleBusiness.circleUpdateStream.listen((ids) {
      _pendingIds.addAll(ids.where((id) => id.trim().isNotEmpty));
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 200), () {
        final pending = _pendingIds.toList(growable: false);
        _pendingIds.clear();
        updateCirclesByIds(pending);
      });
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _debounce?.cancel();
    return super.close();
  }

  Future<void> init() async {
    _logger.info({'text': '开始加载圈子列表'});
    final list = await _circleBusiness.getCircleList();
    final nextMap = <String, CircleInfo>{};
    for (final item in list) {
      nextMap[item.conversationId] = item;
    }
    emit(state.copyWith(circleMap: nextMap, version: state.version + 1));
    _logger.info({
      'text': '圈子列表加载完成',
      'data': {'count': nextMap.length},
    });
  }

  Future<void> updateCirclesByIds(List<String> circleIds) async {
    if (circleIds.isEmpty) {
      _logger.info({'text': '圈子更新ID列表为空，跳过'});
      return;
    }
    _logger.info({
      'text': '按ID更新圈子资料',
      'data': {'count': circleIds.length},
    });

    final circles = await _circleBusiness.getCirclesByIds(circleIds);
    final nextMap = Map<String, CircleInfo>.from(state.circleMap);
    var changed = false;
    final activeIds = <String>{};

    for (final circle in circles) {
      activeIds.add(circle.circleId);
      if (nextMap[circle.conversationId] != circle) {
        nextMap[circle.conversationId] = circle;
        changed = true;
      }
    }

    for (final id in circleIds) {
      final circleId = id.startsWith('circle_') ? id.substring(7) : id;
      if (!activeIds.contains(circleId) &&
          nextMap.remove('circle_$circleId') != null) {
        changed = true;
      }
    }

    if (changed) {
      emit(state.copyWith(circleMap: nextMap, version: state.version + 1));
      _logger.info({'text': '圈子资料已更新'});
    }
  }

  void removeCircle(String circleIdOrConversationId) {
    final conversationId = circleIdOrConversationId.startsWith('circle_')
        ? circleIdOrConversationId
        : 'circle_$circleIdOrConversationId';
    if (!state.circleMap.containsKey(conversationId)) return;
    _logger.info({
      'text': '移除圈子',
      'data': {'conversationId': conversationId},
    });
    final nextMap = Map<String, CircleInfo>.from(state.circleMap)
      ..remove(conversationId);
    emit(state.copyWith(circleMap: nextMap, version: state.version + 1));
  }

  CircleInfo? getCircle(String circleIdOrConversationId) {
    if (circleIdOrConversationId.startsWith('circle_')) {
      return state.circleMap[circleIdOrConversationId];
    }
    return state.circleMap['circle_$circleIdOrConversationId'];
  }
}
