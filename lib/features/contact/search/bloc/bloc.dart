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
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('contact-search');

class SearchContactBloc extends Bloc<SearchContactEvent, SearchContactState> {
  final SearchContactRepository _repository;

  SearchContactBloc(this._repository) : super(const SearchContactState()) {
    on<SearchUserEvent>(_onSearchUser);
    on<AddFriendEvent>(_onAddFriend);
  }

  Future<void> _onSearchUser(
    SearchUserEvent event,
    Emitter<SearchContactState> emit,
  ) async {
    emit(state.copyWith(status: SearchContactStatus.loading));
    _logger.info({'text': '开始搜索用户', 'data': {'query': event.query}});
    try {
      final user = await _repository.searchUser(event.query);
      if (user != null) {
        _logger.info({
          'text': '搜索用户成功',
          'data': {'query': event.query, 'userId': user.userId},
        });
        emit(state.copyWith(status: SearchContactStatus.success, user: user));
      } else {
        _logger.warn({
          'text': '未找到相关用户',
          'data': {'query': event.query},
        });
        emit(
          state.copyWith(
            status: SearchContactStatus.error,
            errorMessage: '未找到相关用户',
          ),
        );
      }
    } catch (e) {
      _logger.error({
        'text': '搜索用户异常',
        'data': {'query': event.query, 'error': e.toString()},
      });
      emit(
        state.copyWith(
          status: SearchContactStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddFriend(
    AddFriendEvent event,
    Emitter<SearchContactState> emit,
  ) async {
    _logger.info({'text': '开始发送好友请求', 'data': {'userId': event.userId}});
    try {
      final response = await _repository.addFriend(event.userId);
      if (response.code == 0) {
        _logger.info({
          'text': '好友请求发送成功',
          'data': {'userId': event.userId},
        });
        emit(
          state.copyWith(
            status: SearchContactStatus.success,
            errorMessage: '好友请求发送成功',
          ),
        );
      } else {
        _logger.error({
          'text': '发送好友请求失败',
          'data': {'userId': event.userId, 'code': response.code, 'msg': response.msg},
        });
        emit(
          state.copyWith(
            status: SearchContactStatus.error,
            errorMessage: response.msg,
          ),
        );
      }
    } catch (e) {
      _logger.error({
        'text': '发送好友请求异常',
        'data': {'userId': event.userId, 'error': e.toString()},
      });
      emit(
        state.copyWith(
          status: SearchContactStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
