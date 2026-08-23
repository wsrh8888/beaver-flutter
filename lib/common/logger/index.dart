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

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// 日志服务
/// 对标大厂移动端：支持控制台输出 + 本地文件持久化 + 自动轮转
class Logger {
  final String moduleName;
  static File? _logFile;
  static const int _maxFileSize = 5242880; // 5MB

  Logger([this.moduleName = '']);

  /// 初始化日志文件
  static Future<void> init() async {
    if (kIsWeb) return;
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
      debugPrint('Logger init failed: $e');
    }
  }

  void info(Map<String, dynamic> msg) {
    _log('info', msg);
  }

  void warn(Map<String, dynamic> msg) {
    _log('warn', msg);
  }

  void error(Map<String, dynamic> msg) {
    _log('error', msg);
  }

  /// 格式化日志结构
  Map<String, dynamic> formatLog(String level, String msg) {
    return {
      "source": "beaver_flutter",
      'level': level,
      "moduleName": moduleName,
      'message': msg,
      'time': DateTime.now().toIso8601String(),
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
}

// 默认全局 logger
final logger = Logger();

