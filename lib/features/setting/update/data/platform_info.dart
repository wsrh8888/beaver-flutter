import 'dart:io';

/// 升级检查使用的平台与架构 ID（与服务端 platform_models 一致）
class UpdatePlatformInfo {
  final int platformId;
  final int archId;

  const UpdatePlatformInfo({
    required this.platformId,
    required this.archId,
  });

  static UpdatePlatformInfo current() {
    if (Platform.isAndroid) {
      return const UpdatePlatformInfo(platformId: 4, archId: 6);
    }
    if (Platform.isIOS) {
      return const UpdatePlatformInfo(platformId: 3, archId: 5);
    }
    return const UpdatePlatformInfo(platformId: 0, archId: 0);
  }
}
