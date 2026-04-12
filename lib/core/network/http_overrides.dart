import 'dart:io';
import 'package:beaver/common/config/config.dart';

/**
 * 核心网络接管组件 (Infrastructure Level)
 * 对标桌面端 app.userAgentFallback，实现底层的流量标识注入。
 */
class BeaverHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // 注入底层标准 User-Agent，确保全 App（含所有第三方库）的网络流量特征归一化
    return super.createHttpClient(context)
      ..userAgent = AppConfig.userAgent;
  }
}
