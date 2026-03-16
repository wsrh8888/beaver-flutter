import 'package:beaver/core/database/database.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/auth/data/repositories/auth_repository.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/api/auth.dart';
import 'package:beaver/types/api/auth.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 认证仓库实现
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<BaseResponse<String>> login(String username, String password) async {
    // 对标桌面端：对密码进行 MD5 哈希
    final hashedPassword = md5.convert(utf8.encode(password)).toString();
    
    final response = await emailPasswordLoginApi(EmailPasswordLoginReq(
      email: username,
      password: hashedPassword,
    ));

    if (response.code == 0 && response.result != null) {
      final result = response.result!;
      final token = result.token;
      final userId = result.userId;

      await StorageUtil.setString('token', token);
      await StorageUtil.setString('userId', userId);

      httpClient.updateToken(token);

      await DatabaseManager.init(userId);

      getIt<WsConnectionManager>().connectWithToken(token);

      print('[Auth] 登录成功，用户: $userId, Token: $token');
      
      return BaseResponse<String>(
        code: 0,
        msg: response.msg,
        result: token,
      );
    }

    return BaseResponse<String>(
      code: response.code,
      msg: response.msg,
      result: null,
    );
  }

  @override
  Future<BaseResponse<bool>> register(String email, String password, String code) async {
    // 对标桌面端：对密码进行 MD5 哈希
    final hashedPassword = md5.convert(utf8.encode(password)).toString();

    final response = await emailRegisterApi(EmailRegisterReq(
      email: email,
      password: hashedPassword,
      code: code,
    ));

    return BaseResponse<bool>(
      code: response.code,
      msg: response.msg,
      result: response.code == 0,
    );
  }

  @override
  Future<BaseResponse<bool>> getEmailCode(String email) async {
    final response = await getEmailCodeApi(GetEmailCodeReq(
      email: email,
      type: 'register', // 这里的 type 根据后端协议设置，桌面端 default 可能是这个
    ));
    return BaseResponse<bool>(
      code: response.code,
      msg: response.msg,
      result: response.code == 0,
    );
  }

  @override
  Future<void> logout() async {
    getIt<WsConnectionManager>().disconnect();
    await StorageUtil.remove('token');
    await StorageUtil.remove('userId');
    await DatabaseManager.close();
  }
}
