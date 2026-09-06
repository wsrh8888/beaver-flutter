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
import 'package:beaver/features/contact/detail/bloc/event.dart';
import 'package:beaver/features/contact/detail/bloc/state.dart';
import 'package:beaver/features/contact/detail/data/repositories/repository.dart';
import 'package:beaver/features/contact/detail/data/models/user_info.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('contact-detail');

class ContactDetailBloc extends Bloc<DetailEvent, DetailState> {
  final DetailRepository _detailRepository;

  ContactDetailBloc({DetailRepository? detailRepository}) 
    : _detailRepository = detailRepository ?? DetailRepository(),
      super(const DetailState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
    on<ToggleMoreMenuEvent>(_onToggleMoreMenu);
    on<ShowEditNoteDialogEvent>(_onShowEditNoteDialog);
    on<CloseEditNoteDialogEvent>(_onCloseEditNoteDialog);
    on<SaveRemarkNameEvent>(_onSaveRemarkName);
    on<DeleteFriendEvent>(_onDeleteFriend);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearNavigationEvent>(_onClearNavigation);
    on<AudioCallEvent>(_onAudioCall);
    on<VideoCallEvent>(_onVideoCall);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading));
    _logger.info({'text': '加载联系人资料', 'data': {'userId': event.userId}});

    try {
      final userInfo = await _detailRepository.getUserInfo(event.userId);
      emit(state.copyWith(
        status: DetailStatus.success,
        userInfo: userInfo,
        isFriend: true, 
      ));
      _logger.info({
        'text': '联系人资料加载完成',
        'data': {'userId': event.userId, 'nickname': userInfo?.nickname},
      });
    } catch (e) {
      _logger.error({
        'text': '加载联系人资料失败',
        'data': {'userId': event.userId, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '加载用户信息失败: $e',
      ));
    }
  }

  Future<void> _onToggleMoreMenu(
    ToggleMoreMenuEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(showMoreMenu: !state.showMoreMenu));
  }

  Future<void> _onShowEditNoteDialog(
    ShowEditNoteDialogEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(
      showEditNoteDialog: true,
      newRemarkName: state.userInfo?.remarkName,
    ));
  }

  Future<void> _onCloseEditNoteDialog(
    CloseEditNoteDialogEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(showEditNoteDialog: false));
  }

  Future<void> _onSaveRemarkName(
    SaveRemarkNameEvent event,
    Emitter<DetailState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: DetailStatus.loading));
    _logger.info({
      'text': '保存好友备注',
      'data': {'userId': state.userInfo!.userId, 'remarkName': event.remarkName},
    });

    try {
      final success = await _detailRepository.updateRemarkName(
        state.userInfo!.userId,
        event.remarkName,
      );
      if (!success) {
        _logger.warn({
          'text': '保存好友备注失败',
          'data': {'userId': state.userInfo!.userId},
        });
        emit(state.copyWith(
          status: DetailStatus.error,
          errorMessage: '更新备注失败',
        ));
        return;
      }
      final updatedUserInfo = state.userInfo!.copyWith(remarkName: event.remarkName);
      emit(state.copyWith(
        status: DetailStatus.success,
        userInfo: updatedUserInfo,
        showEditNoteDialog: false,
      ));
      _logger.info({
        'text': '好友备注保存成功',
        'data': {'userId': state.userInfo!.userId},
      });
    } catch (e) {
      _logger.error({
        'text': '保存好友备注异常',
        'data': {'userId': state.userInfo!.userId, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '更新备注失败: $e',
      ));
    }
  }

  Future<void> _onDeleteFriend(
    DeleteFriendEvent event,
    Emitter<DetailState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: DetailStatus.loading));
    _logger.info({
      'text': '删除好友',
      'data': {'userId': state.userInfo!.userId},
    });

    try {
      await _detailRepository.deleteFriend(state.userInfo!.userId);
      emit(state.copyWith(
        status: DetailStatus.success,
        isFriend: false,
        showMoreMenu: false,
      ));
      _logger.info({
        'text': '好友删除成功',
        'data': {'userId': state.userInfo!.userId},
      });
    } catch (e) {
      _logger.error({
        'text': '删除好友异常',
        'data': {'userId': state.userInfo!.userId, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '删除好友失败: $e',
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<DetailState> emit,
  ) async {
    if (state.userInfo?.conversationId != null) {
      _logger.info({
        'text': '从联系人资料发起聊天',
        'data': {'userId': state.userInfo?.userId, 'conversationId': state.userInfo?.conversationId},
      });
      emit(state.copyWith(
        navigateToChat: true,
        conversationIdForChat: state.userInfo?.conversationId,
      ));
    } else {
      _logger.warn({
        'text': '联系人资料缺少会话ID，无法发起聊天',
        'data': {'userId': state.userInfo?.userId},
      });
    }
  }

  Future<void> _onClearNavigation(
    ClearNavigationEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(
      navigateToChat: false,
      conversationIdForChat: null,
    ));
  }

  Future<void> _onAudioCall(
    AudioCallEvent event,
    Emitter<DetailState> emit,
  ) async {
    // 模拟音频通话
  }

  Future<void> _onVideoCall(
    VideoCallEvent event,
    Emitter<DetailState> emit,
  ) async {
    // 模拟视频通话
  }
}

