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

import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/call.dart';
import 'package:beaver/types/call.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-calls-history');

class CallHistoryRepository {
  final CallRepositoryInterface _callRepository;

  CallHistoryRepository({CallRepositoryInterface? callRepository}) 
    : _callRepository = callRepository ?? getIt<CallRepositoryInterface>();

  Future<List<CallHistory>> getCallHistory() async {
    try {

    return _callRepository.getCallHistory();
    } catch (e, st) {
      _logger.warn({'text':'CallHistoryRepository.getCallHistory 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
  
  Future<bool> deleteCallHistory(String callId) async {
    try {

    return _callRepository.deleteCallHistory(callId);
    } catch (e, st) {
      _logger.warn({'text':'CallHistoryRepository.deleteCallHistory 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
  
  Future<bool> clearCallHistory() async {
    try {
    _logger.info({'text':'CallHistoryRepository.clearCallHistory 开始执行','data':{}});

    return _callRepository.clearCallHistory();
    } catch (e, st) {
      _logger.warn({'text':'CallHistoryRepository.clearCallHistory 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}
