import 'dart:convert';

/// 日志服务
class Logger {
  final String moduleName;

  Logger([this.moduleName = '']);

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
      'time': DateTime.now().millisecondsSinceEpoch,
    };
  }

  void _log(String level, Map<String, dynamic> msg) {
    // 业务数据直接转换为 JSON 字符串作为 message 字段
    final String jsonMessage = jsonEncode(msg);

    // 调用 formatLog 生成包含元数据的完整日志条目
    // final Map<String, dynamic> logEntry = formatLog(level, jsonMessage);

    // 最终控制台输出完整的 JSON 结构
    // ignore: avoid_print
    print(jsonMessage);
  }
}

// 默认全局 logger
final logger = Logger();
