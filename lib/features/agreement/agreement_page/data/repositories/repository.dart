import 'package:beaver/features/agreement/agreement_page/data/models/agreement.dart';

class AgreementRepository {
  Future<Agreement> getAgreement() async {
    // 模拟获取用户协议
    await Future.delayed(const Duration(seconds: 1));
    return const Agreement(
      title: 'Beaver用户服务协议',
      updateTime: '2025年4月3日',
      content: '欢迎您使用Beaver！本协议是您与Beaver之间关于使用我们提供的产品和服务的法律协议。请您在注册和使用前仔细阅读本协议的全部内容。',
    );
  }
}
