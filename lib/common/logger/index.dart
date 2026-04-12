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

