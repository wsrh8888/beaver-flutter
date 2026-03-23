/// 日志服务
/// 
/// 职责：提供应用级日志能力
/// - 日志记录
/// - 日志级别控制
/// - 日志上报
class LoggerService {
  void info(String message) {
    print('[INFO] $message');
  }

  void debug(String message) {
    print('[DEBUG] $message');
  }

  void warn(String message) {
    print('[WARN] $message');
  }

  void error(String message, [dynamic error]) {
    print('[ERROR] $message ${error ?? ''}');
  }
}

final logger = LoggerService();
