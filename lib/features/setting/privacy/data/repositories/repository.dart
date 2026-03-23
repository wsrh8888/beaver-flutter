import 'package:beaver/features/setting/privacy/data/models/privacy.dart';

class PrivacyRepository {
  Future<PrivacyPolicy> getPrivacyPolicy() async {
    return const PrivacyPolicy(
      title: '隐私政策',
      updateTime: '2025年01月01日',
      content: 'Beaver重视您的隐私。本隐私政策说明了我们如何收集、使用、披露、处理和保护您在使用我们的服务时所提供的信息。请您仔细阅读本政策，了解我们的隐私惯例。',
    );
  }
}