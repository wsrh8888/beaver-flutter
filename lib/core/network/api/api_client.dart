import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../config/config.dart';
import '../request/request.dart';
import '../../../shared/utils/storage_util.dart';

/// 基于 Dio 的 HTTP 客户端 (对标 desktop render/utils/request/ajax.ts)
class ApiClient {
  late Dio _dio;
  final String baseUrl;
  String? _cachedToken;

  ApiClient({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. 获取 Token (优先内存，其次本地存储)
        _cachedToken ??= await StorageUtil.getString('token');

        // 2. 注入 Standard Headers (对标 ajax.ts)
        final now = DateTime.now();
        final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
        final uuid = const Uuid().v4();

        options.headers.addAll({
          'source': 'beaver-flutter',
          'timestamp': timestamp,
          'env': currentEnv.name,
          'deviceId': await StorageUtil.getDeviceId(),
          'version': AppConfig.version,
          'token': _cachedToken ?? '',
          'uuid': uuid,
        });

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 全局日志打印 (对标 ajax.ts 的 logger.info)
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] != 0) {
           print('[API] 业务异常: ${data['msg']}');
        }
        return handler.next(response);
      },
      onError: (err, handler) {
        print('[API] 网络异常: ${err.message}');
        return handler.next(err);
      },
    ));
  }

  Future<BaseResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return BaseResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponse(code: -1, msg: e.toString());
    }
  }

  Future<BaseResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return BaseResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponse(code: -1, msg: e.toString());
    }
  }

  // 更新 Token (登录成功后调用)
  void updateToken(String token) {
    _cachedToken = token;
  }
}
