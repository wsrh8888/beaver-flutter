import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * UA 模块第二层：适配层 (HttpAdapter)
 * 职责：接管系统级 HttpClient，实现 User-Agent 的全局静默注入。
 */
class BeaverUaHttpAdapter extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // 强制挂载 UA 模块生成的标识符
    return super.createHttpClient(context)
      ..userAgent = AppConfig.userAgent;
  }
}
