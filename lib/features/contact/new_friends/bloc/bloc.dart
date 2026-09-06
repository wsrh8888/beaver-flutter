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
import 'package:beaver/features/contact/new_friends/bloc/event.dart';
import 'package:beaver/features/contact/new_friends/bloc/state.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/features/contact/new_friends/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('new-friends');

class NewFriendsBloc extends Bloc<NewFriendsEvent, NewFriendsState> {
  final NewFriendsRepository _repository = NewFriendsRepository();

  NewFriendsBloc() : super(const NewFriendsState()) {
    on<LoadFriendRequestsEvent>(_onLoadFriendRequests);
    on<SwitchTabEvent>(_onSwitchTab);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<RejectRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadFriendRequests(
    LoadFriendRequestsEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));
    _logger.info({'text': '开始加载好友请求列表'});

    final friendRequests = await _repository.getFriendRequests();
    _logger.info({
      'text': '好友请求列表加载完成',
      'data': {'count': friendRequests.length},
    });
    emit(
      state.copyWith(
        status: NewFriendsStatus.success,
        friendRequests: friendRequests,
      ),
    );
  }

  Future<void> _onSwitchTab(
    SwitchTabEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));
    _logger.info({'text': '开始接受好友请求', 'data': {'id': event.id}});

    final response = await _repository.updateRequestStatus(event.id, 1);

    if (response.code == 0) {
      _logger.info({'text': '接受好友请求成功', 'data': {'id': event.id}});
      final updatedRequests = state.friendRequests.map((request) {
        if (request.id == event.id) {
          return FriendRequest(
            id: request.id,
            nickname: request.nickname,
            fileName: request.fileName,
            message: request.message,
            source: request.source,
            flag: request.flag,
            status: 1,
            createdAt: request.createdAt,
          );
        }
        return request;
      }).toList();
      emit(
        state.copyWith(
          status: NewFriendsStatus.success,
          friendRequests: updatedRequests,
        ),
      );
    } else {
      _logger.error({
        'text': '接受好友请求失败',
        'data': {'id': event.id, 'code': response.code, 'msg': response.msg},
      });
      emit(
        state.copyWith(
          status: NewFriendsStatus.error,
          errorMessage: response.msg,
        ),
      );
    }
  }

  Future<void> _onRejectRequest(
    RejectRequestEvent event,
    Emitter<NewFriendsState> emit,
  ) async {
    emit(state.copyWith(status: NewFriendsStatus.loading));
    _logger.info({'text': '开始拒绝好友请求', 'data': {'id': event.id}});

    final response = await _repository.updateRequestStatus(event.id, 2);

    if (response.code == 0) {
      _logger.info({'text': '拒绝好友请求成功', 'data': {'id': event.id}});
      final updatedRequests = state.friendRequests.map((request) {
        if (request.id == event.id) {
          return FriendRequest(
            id: request.id,
            nickname: request.nickname,
            fileName: request.fileName,
            message: request.message,
            source: request.source,
            flag: request.flag,
            status: 2,
            createdAt: request.createdAt,
          );
        }
        return request;
      }).toList();
      emit(
        state.copyWith(
          status: NewFriendsStatus.success,
          friendRequests: updatedRequests,
        ),
      );
    } else {
      _logger.error({
        'text': '拒绝好友请求失败',
        'data': {'id': event.id, 'code': response.code, 'msg': response.msg},
      });
      emit(
        state.copyWith(
          status: NewFriendsStatus.error,
          errorMessage: response.msg,
        ),
      );
    }
  }
}
