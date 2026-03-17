import 'package:beaver/api/auth.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/common/request/request.dart';

class RegisterRepository {
  Future<BaseResponse<EmailRegisterRes>> register(String email, String password, String code) async {
    final req = EmailRegisterReq(email: email, password: password, code: code);
    return await emailRegisterApi(req);
  }
}
