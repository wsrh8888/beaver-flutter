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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/forget/bloc/event.dart';
import 'package:beaver/features/auth/forget/bloc/state.dart';
import 'package:beaver/features/auth/forget/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('forget');

class ForgetBloc extends Bloc<ForgetEvent, ForgetState> {
  final ForgetRepository _repository;
  Timer? _countdownTimer;

  ForgetBloc(this._repository) : super(const ForgetState()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<ResetPasswordEvent>(_onResetPassword);
    on<UpdateCountdownEvent>(_onUpdateCountdown);
    on<ResetCountdownEvent>(_onResetCountdown);
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCodeEvent event,
    Emitter<ForgetState> emit,
  ) async {
    _logger.info({
      'text': '发送找回密码验证码',
      'data': {'email': event.request.email},
    });
    emit(state.copyWith(
      status: ForgetStatus.sendingCode,
      isCodeButtonDisabled: true,
    ));

    try {
      final success = await _repository.sendVerificationCode(event.request);
      if (success) {
        _logger.info({
          'text': '验证码发送成功',
          'data': {'email': event.request.email},
        });
        emit(state.copyWith(
          status: ForgetStatus.success,
          errorMessage: '验证码已发送',
        ));
        _startCountdown();
      } else {
        _logger.warn({
          'text': '验证码发送失败（接口返回失败）',
          'data': {'email': event.request.email},
        });
        emit(state.copyWith(
          status: ForgetStatus.error,
          errorMessage: '发送失败',
          isCodeButtonDisabled: false,
        ));
      }
    } catch (e) {
      _logger.error({
        'text': '验证码发送异常',
        'data': {'email': event.request.email, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: ForgetStatus.error,
        errorMessage: '发送失败: $e',
        isCodeButtonDisabled: false,
      ));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgetState> emit,
  ) async {
    _logger.info({
      'text': '提交重置密码',
      'data': {'email': event.request.email},
    });
    emit(state.copyWith(status: ForgetStatus.resettingPassword));

    try {
      final success = await _repository.resetPassword(event.request);
      if (success) {
        _logger.info({
          'text': '密码重置成功',
          'data': {'email': event.request.email},
        });
        emit(state.copyWith(
          status: ForgetStatus.success,
          errorMessage: '密码重置成功',
        ));
      } else {
        _logger.warn({
          'text': '密码重置失败（接口返回失败）',
          'data': {'email': event.request.email},
        });
        emit(state.copyWith(
          status: ForgetStatus.error,
          errorMessage: '重置失败',
        ));
      }
    } catch (e) {
      _logger.error({
        'text': '密码重置异常',
        'data': {'email': event.request.email, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: ForgetStatus.error,
        errorMessage: '重置失败: $e',
      ));
    }
  }

  Future<void> _onUpdateCountdown(
    UpdateCountdownEvent event,
    Emitter<ForgetState> emit,
  ) async {
    if (state.countdown > 0) {
      emit(state.copyWith(
        countdown: state.countdown - 1,
      ));
    } else {
      _countdownTimer?.cancel();
      emit(state.copyWith(
        isCodeButtonDisabled: false,
        countdown: 60,
      ));
    }
  }

  Future<void> _onResetCountdown(
    ResetCountdownEvent event,
    Emitter<ForgetState> emit,
  ) async {
    _countdownTimer?.cancel();
    emit(state.copyWith(
      isCodeButtonDisabled: false,
      countdown: 60,
    ));
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateCountdownEvent());
    });
  }
}
