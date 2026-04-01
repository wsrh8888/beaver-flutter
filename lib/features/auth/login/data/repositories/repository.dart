import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:beaver/api/auth.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/common/request/request.dart';

class LoginRepository {
  Future<BaseResponse<EmailPasswordLoginRes>> login(
    String email,
    String password,
  ) async {
    final deviceId = await StorageUtil.getDeviceId();
    final req = EmailPasswordLoginReq(
      email: email,
      // 使用 MD5 加密密码
      password: md5.convert(utf8.encode(password)).toString(),
      deviceId: deviceId,
    );
    final response = await emailPasswordLoginApi(req);

    if (response.code == 0 && response.result != null) {
      await StorageUtil.setString('token', response.result!.token);
      await StorageUtil.setString('userId', response.result!.userId);
    }
    return response;
  }
}
