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
import 'package:beaver/features/calls/history/bloc/event.dart';
import 'package:beaver/features/calls/history/bloc/state.dart';
import 'package:beaver/features/calls/history/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('call-history');

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  final CallHistoryRepository _callHistoryRepository;
  
  CallHistoryBloc({CallHistoryRepository? callHistoryRepository}) 
    : _callHistoryRepository = callHistoryRepository ?? CallHistoryRepository(),
      super(const CallHistoryState()) {
    on<LoadCallHistoryEvent>(_onLoadCallHistory);
    on<DeleteCallHistoryEvent>(_onDeleteCallHistory);
    on<ClearCallHistoryEvent>(_onClearCallHistory);
  }
  
  Future<void> _onLoadCallHistory(
    LoadCallHistoryEvent event,
    Emitter<CallHistoryState> emit,
  ) async {
    _logger.info({'text': '加载通话记录', 'data': {}});
    emit(state.copyWith(isLoading: true));

    try {
      final callHistoryList = await _callHistoryRepository.getCallHistory();
      _logger.info({
        'text': '加载通话记录成功',
        'data': {'count': callHistoryList.length},
      });
      emit(state.copyWith(
        isLoading: false,
        callHistoryList: callHistoryList,
      ));
    } catch (e) {
      _logger.error({
        'text': '加载通话记录失败',
        'data': {'error': e.toString()},
      });
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
    _logger.info({
      'text': '删除单条通话记录',
      'data': {'callId': event.callId},
    });
    try {
      final success = await _callHistoryRepository.deleteCallHistory(event.callId);
      if (success) {
        final updatedList = state.callHistoryList.where((call) => call.id != event.callId).toList();
        emit(state.copyWith(callHistoryList: updatedList));
      } else {
        _logger.warn({
          'text': '删除单条通话记录失败（接口返回失败）',
          'data': {'callId': event.callId},
        });
      }
    } catch (e) {
      _logger.error({
        'text': '删除单条通话记录异常',
        'data': {'callId': event.callId, 'error': e.toString()},
      });
      emit(state.copyWith(
        errorMessage: '删除通话历史失败: $e',
      ));
    }
  }

  Future<void> _onClearCallHistory(
    ClearCallHistoryEvent event,
    Emitter<CallHistoryState> emit,
  ) async {
    _logger.info({'text': '清空通话记录', 'data': {}});
    try {
      final success = await _callHistoryRepository.clearCallHistory();
      if (success) {
        emit(state.copyWith(callHistoryList: []));
      } else {
        _logger.warn({'text': '清空通话记录失败（接口返回失败）', 'data': {}});
      }
    } catch (e) {
      _logger.error({
        'text': '清空通话记录异常',
        'data': {'error': e.toString()},
      });
      emit(state.copyWith(
        errorMessage: '清空通话历史失败: $e',
      ));
    }
  }
}
