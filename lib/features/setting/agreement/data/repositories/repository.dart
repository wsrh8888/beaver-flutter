import 'package:beaver/features/setting/agreement/data/models/agreement.dart';

class AgreementRepository {
  Future<Agreement> getAgreement() async {
    return const Agreement(
      title: '用户协议',
      updateTime: '2025年01月01日',
      content: '欢迎来到Beaver。通过使用我们的服务，您同意以下条款。请您仔细阅读。如果您不同意这些条款，请勿使用我们的服务。',
    );
  }
}