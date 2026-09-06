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
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/common/logger/index.dart';

// 模块级日志实例（对标 PC：在文件顶部定义 logger）
final _logger = Logger('login');

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
  }

  Future<void> _onLoginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    _logger.info({'text': '登录请求开始'});

    try {
      final response = await authRepository.login(event.email, event.password);
      _logger.info({
        'text': '登录接口返回',
        'data': {
          'code': response.code,
          'hasResult': response.result != null,
        },
      });
      if (response.code == 0 && response.result != null) {
        final appStore = getIt<AppStore>();
        // 重要：登录成功后，必须立即初始化数据库，以便首页能读取到本地数据
        _logger.info({'text': '登录成功，初始化本地数据库'});
        await appStore.initUserDatabase(response.result!.userId);

        // 1. 先跳转到首页 (通过 emit success 状态)
        emit(state.copyWith(status: LoginStatus.success));
        _logger.info({'text': '登录成功，跳转首页'});

        // 2. 异步连接 WebSocket (不再阻塞 UI 跳转)
        // 使用 Future.microtask 或直接调用，因为它已经是一个异步过程的开始
        Future.microtask(() {
          _logger.info({'text': '异步连接WebSocket'});
          getIt<WsConnectionManager>().connectWithToken(response.result!.token);
        });
      } else {
        _logger.warn({
          'text': '登录失败',
          'data': {'code': response.code, 'msg': response.msg},
        });
        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorMessage: response.msg ?? '登录失败',
          ),
        );
      }
    } catch (e) {
      _logger.error({'text': '登录异常', 'data': {'error': e.toString()}});
      emit(
        state.copyWith(status: LoginStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
