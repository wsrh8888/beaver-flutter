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
import 'package:beaver/features/auth/register/bloc/event.dart';
import 'package:beaver/features/auth/register/bloc/state.dart';
import 'package:beaver/features/auth/register/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('register');

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository authRepository;
  
  RegisterBloc({required this.authRepository}) : super(const RegisterState()) {
    on<RegisterSubmitEvent>(_onRegisterSubmit);
  }
  
  Future<void> _onRegisterSubmit(RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    _logger.info({
      'text': '提交注册',
      'data': {'email': event.email},
    });
    emit(state.copyWith(status: RegisterStatus.loading));
    
    try {
      await authRepository.register(
        event.email,
        event.password,
        event.confirmPassword,
      );
      _logger.info({
        'text': '注册成功',
        'data': {'email': event.email},
      });
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      _logger.error({
        'text': '注册失败',
        'data': {'email': event.email, 'error': e.toString()},
      });
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
