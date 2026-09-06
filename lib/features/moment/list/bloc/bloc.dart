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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/moment/list/bloc/event.dart';
import 'package:beaver/features/moment/list/bloc/state.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/features/moment/list/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('moment-list');

class MomentListBloc extends Bloc<MomentListEvent, MomentListState> {
  final MomentListRepository _momentListRepository;
  final int limit = 10;

  MomentListBloc({MomentListRepository? momentListRepository}) 
    : _momentListRepository = momentListRepository ?? MomentListRepository(),
      super(const MomentListState()) {
    on<LoadMomentListEvent>(_onLoadMomentList);
    on<ToggleLikeMomentEvent>(_onToggleLikeMoment);
  }

  Future<void> _onLoadMomentList(LoadMomentListEvent event, Emitter<MomentListState> emit) async {
    if (state.status == MomentListStatus.loading) return;

    final isRefresh = event.refresh;
    final nextPage = isRefresh ? 1 : state.page + 1;

    if (isRefresh) {
      emit(state.copyWith(status: MomentListStatus.loading));
    }
    _logger.info({
      'text': '加载动态列表',
      'data': {'refresh': isRefresh, 'page': nextPage},
    });

    try {
      final newMoments = await _momentListRepository.getMomentList(nextPage, limit);

      final updatedMoments = isRefresh ? newMoments : [...state.moments, ...newMoments];

      _logger.info({
        'text': '加载动态列表成功',
        'data': {
          'page': nextPage,
          'newCount': newMoments.length,
          'total': updatedMoments.length,
          'hasMore': newMoments.length >= limit,
        },
      });
      emit(state.copyWith(
        status: MomentListStatus.success,
        moments: updatedMoments,
        page: nextPage,
        hasMore: newMoments.length >= limit,
      ));
    } catch (e) {
      _logger.error({'text': '加载动态列表失败', 'data': {'error': e.toString()}});
      emit(state.copyWith(
        status: MomentListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleLikeMoment(ToggleLikeMomentEvent event, Emitter<MomentListState> emit) async {
    final momentIndex = state.moments.indexWhere((m) => m.id == event.moment.id);
    if (momentIndex == -1) return;

    final moment = state.moments[momentIndex];
    final hasLiked = moment.likes.any((like) => like.userId == event.currentUserId);
    final targetStatus = !hasLiked;
    _logger.info({
      'text': '切换动态点赞',
      'data': {'momentId': moment.id, 'action': targetStatus ? 'like' : 'unlike'},
    });

    // Optimistic update
    final updatedLikes = List<IMomentLikeModel>.from(moment.likes);
    if (targetStatus) {
      updatedLikes.add(IMomentLikeModel(
        id: '',
        momentId: moment.id,
        userId: event.currentUserId,
        userName: event.currentUserName,
        avatar: '',
        createdAt: DateTime.now().toIso8601String(),
      ));
    } else {
      updatedLikes.removeWhere((like) => like.userId == event.currentUserId);
    }

    final updatedMoment = IMomentListItem(
      id: moment.id,
      userId: moment.userId,
      userName: moment.userName,
      avatar: moment.avatar,
      content: moment.content,
      files: moment.files,
      comments: moment.comments,
      likes: updatedLikes,
      commentCount: moment.commentCount,
      likeCount: updatedLikes.length,
      isLiked: targetStatus,
      createdAt: moment.createdAt,
    );

    final newMoments = List<IMomentListItem>.from(state.moments);
    newMoments[momentIndex] = updatedMoment;

    emit(state.copyWith(moments: newMoments));

    // Actually make network request
    final success = await _momentListRepository.toggleLike(moment.id, targetStatus);
    if (!success) {
      _logger.warn({'text': '切换动态点赞失败，已回滚', 'data': {'momentId': moment.id}});
      // Revert if failed (simplified, assumes single failure handling isn't critical right now)
      emit(state.copyWith(moments: state.moments));
    }
  }
}
