import 'package:beaver/features/guide/guide_page/data/models/guide.dart';

class GuideRepository {
  Future<GuideConfig> getGuideConfig() async {
    // 模拟获取引导页配置
    await Future.delayed(const Duration(seconds: 1));
    return GuideConfig(
      logo: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=messaging%20app%20logo%20on%20gradient%20background&size=1024x1024',
    );
  }
}
