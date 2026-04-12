import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * 全局 HTTP 覆盖类 (对标桌面端 app.userAgentFallback)
 * 强制所有基于 dart:io 的请求自动携带标准 Beaver UA
 */
class BeaverHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // 调用系统创建逻辑后，立即注入咱们特有的 userAgent
    return super.createHttpClient(context)
      ..userAgent = AppConfig.userAgent;
  }
}
