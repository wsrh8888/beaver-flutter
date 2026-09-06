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
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/common/config/env.dart';

/// 日志服务
///
/// 对标 PC 端 Logger：控制台输出 + 本地文件持久化 + 云端上报。
/// 云端公共参数与 PC 端完全一致（便于同一套后台聚合检索）：
/// Level / message / module / source / user_id / device_id /
/// platform / project_name / version / timestamp
///
/// 约束：调用方传入的 [msg] 必须以中文 `text` 字段描述（不允许纯英文 text），
/// 业务变量统一放入 `data`，例如：
/// ```dart
/// logger.info({ 'text': '开始发送消息', 'data': { 'messageId': id } });
/// ```
class Logger {
  final String moduleName;
  static File? _logFile;
  static const int _maxFileSize = 5242880; // 5MB

  // ---- 云端上报相关 ----
  // 独立实例：刻意不走 HttpClient 拦截器，避免日志请求再次触发 Logger 造成递归上报
  static const String _cloudPath = '/api/platform/track_public/v1/track';
  static Dio? _cloudDio;
  static bool _cloudEnabled = false;
  static String? _userId; // 登录成功后由业务层注入
  static final List<Map<String, dynamic>> _buffer = [];
  static bool _flushing = false;
  static Timer? _flushTimer;
  static const int _maxBatch = 10; // 缓冲达到该条数立即上报
  static const Duration _flushInterval = Duration(seconds: 15); // 定时兜底上报

  Logger([this.moduleName = '']);

  /// 注入当前用户 ID（登录成功 / 用户初始化后调用；登出时传 null）
  static void setUserId(String? userId) {
    _userId = userId;
  }

  /// 初始化：本地日志文件 + 云端上报通道
  static Future<void> init() async {
    // 1. 本地文件（仅非 Web 平台）
    if (!kIsWeb) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final logDir = Directory('${directory.path}/logs');
        if (!await logDir.exists()) {
          await logDir.create(recursive: true);
        }
        _logFile = File('${logDir.path}/app.log');

        // 检查文件大小并实现简单轮转
        if (await _logFile!.exists()) {
          final size = await _logFile!.length();
          if (size > _maxFileSize) {
            await _logFile!.rename('${logDir.path}/app_old.log');
            _logFile = File('${logDir.path}/app.log');
          }
        }
      } catch (e) {
        debugPrint('Logger local init failed: $e');
      }
    }

    // 2. 云端上报独立通道（与本地文件解耦，移动端全程可用）
    _initCloud();
  }

  /// 初始化云端上报的独占 Dio（不挂任何拦截器）
  static void _initCloud() {
    try {
      _cloudDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json;charset=UTF-8'},
        ),
      );
      _cloudEnabled = true;
      // 定时兜底上报：避免仅有 info 日志时缓冲长期不刷新
      _flushTimer?.cancel();
      _flushTimer = Timer.periodic(_flushInterval, (_) => _flushCloud());
    } catch (e) {
      debugPrint('Logger cloud init failed: $e');
    }
  }

  void info(Map<String, dynamic> msg) => _log('info', msg);

  void warn(Map<String, dynamic> msg) => _log('warn', msg);

  void error(Map<String, dynamic> msg) => _log('error', msg);

  /// 组装与 PC 端一致的云端公共参数
  /// [jsonMessage] 为业务 msg 的 JSON 字符串（对标 PC 的 `${JSON.stringify(msg)}`）
  Map<String, dynamic> formatLog(String level, String jsonMessage) {
    String deviceId = '';
    String platform = '';
    String version = '';
    try {
      deviceId = AppConfig.deviceId;
      platform = Platform.isIOS ? 'ios' : 'android';
      version = AppConfig.version;
    } catch (_) {
      // AppConfig 尚未初始化时静默降级，不阻断业务
    }
    return {
      'Level': level,
      'message': jsonMessage,
      'module': moduleName,
      'source': 'flutter',
      'user_id': _userId ?? '',
      'device_id': deviceId,
      'platform': platform,
      'project_name': 'beaver-flutter',
      'version': version,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  void _log(String level, Map<String, dynamic> msg) {
    // 业务数据直接转换为 JSON 字符串作为 message 字段
    final String jsonMessage = jsonEncode(msg);

    // 调用 formatLog 生成包含元数据的完整日志条目
    final Map<String, dynamic> logEntry = formatLog(level, jsonMessage);
    final String fullLog = jsonEncode(logEntry);

    // 1. 控制台输出 (Debug 模式)
    if (kDebugMode) {
      // ignore: avoid_print
      print('[$level][$moduleName] $jsonMessage');
    }

    // 2. 本地持久化 (对标大厂：离线排查、用户反馈附件)
    _writeToLocal(fullLog);

    // 3. 云端上报缓冲（error/warn 实时上报，info 累积或定时上报）
    _bufferLog(logEntry, level);
  }

  /// 追加到缓冲，并按策略触发上报
  void _bufferLog(Map<String, dynamic> entry, String level) {
    if (!_cloudEnabled || _cloudDio == null) return;
    _buffer.add(entry);
    if (level == 'error' || level == 'warn' || _buffer.length >= _maxBatch) {
      unawaited(_flushCloud());
    }
  }

  /// 将缓冲中的日志批量上报至云端（独立 Dio，失败仅本地打印，绝不抛错阻断业务）
  static Future<void> _flushCloud() async {
    if (_cloudDio == null || _buffer.isEmpty) return;
    if (_flushing) return;
    _flushing = true;

    // 复制当前批次并清空缓冲，期间新日志进入下一轮
    final batch = List<Map<String, dynamic>>.from(_buffer);
    _buffer.clear();

    try {
      await _cloudDio!.post(
        '$baseUrl$_cloudPath',
        data: {'logs': batch},
      );
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Logger cloud upload failed: $e');
      }
    } finally {
      _flushing = false;
    }
  }

  void _writeToLocal(String log) {
    if (_logFile == null) return;
    try {
      // 异步追加，不阻塞 UI
      _logFile!.writeAsString('$log\n', mode: FileMode.append, flush: false);
    } catch (e) {
      // ignore: avoid_print
      if (kDebugMode) print('Failed to write log to file: $e');
    }
  }

  /// 释放资源：取消定时上报并做最后一次兜底上报
  static Future<void> stop() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    await _flushCloud();
    _cloudEnabled = false;
  }
}

// 默认全局 logger（未指定模块时使用，谨慎依赖；各业务文件应各自在顶部定义自己的 _logger）
final _logger = Logger();
