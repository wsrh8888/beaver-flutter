import 'package:beaver/common/logger/index.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/shared/utils/storage_util.dart';

/// HTTP 响应基础包装类
class BaseResponse<T> {
  final int code;
  final String msg;
  final T? result;

  BaseResponse({required this.code, required this.msg, this.result});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponse<T>(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      result: fromJsonT != null && json['result'] != null
          ? fromJsonT(json['result'])
          : (json['result'] is T ? json['result'] as T : null),
    );
  }

  bool get isSuccess => code == 0;
}

/// HTTP 客户端封装
class HttpClient {
  final Dio _dio;
  final _logger = Logger('http');

  HttpClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(milliseconds: 50000),
          receiveTimeout: const Duration(milliseconds: 50000),
          headers: {'Content-Type': 'application/json;charset=UTF-8'},
        ),
      ) {
    // 请求拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 1. 从 config、env、storage 各处取值，组装大厂标准公参
          final token = StorageUtil.getString('token');
          final timestamp = DateFormat(
            'yyyy-MM-dd HH:mm:ss.SSS',
          ).format(DateTime.now());

          options.headers.addAll({
            'source': AppConfig.source,
            'version': AppConfig.version,
            'timestamp': timestamp,
            'env': currentEnv.name,
            'deviceId': AppConfig.deviceId,
            if (token != null && token.isNotEmpty) 'token': token,
          });

          // 2. 注入请求唯一 ID
          options.headers['uuid'] = const Uuid().v4();

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;
          final int code = (data is Map) ? (data['code'] ?? 0) : 0;

          // 处理 FormData 避免日志 jsonEncode 失败
          final requestData = response.requestOptions.data;
          final logRequestData = (requestData is FormData)
              ? "[FormData]"
              : requestData;

          if (code == 0) {
            _logger.info({
              'text': '接口成功',
              'url': response.requestOptions.path,
              'method': response.requestOptions.method,
              'status': response.statusCode,
              'requestParameters': response.requestOptions.queryParameters,
              'requestData': logRequestData,
              'headers': response.requestOptions.headers,
              'data': response.data,
            });
          } else {
            _logger.warn({
              'text': '状态码异常',
              'url': response.requestOptions.path,
              'method': response.requestOptions.method,
              'status': response.statusCode,
              'code': code,
              'requestParameters': response.requestOptions.queryParameters,
              'requestData': logRequestData,
              'headers': response.requestOptions.headers,
              'data': response.data,
            });
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          final requestData = error.requestOptions.data;
          final logRequestData = (requestData is FormData)
              ? "[FormData]"
              : requestData;

          _logger.error({
            'text': '接口异常',
            'url': error.requestOptions.path,
            'method': error.requestOptions.method,
            'error': error.message,
            'requestParameters': error.requestOptions.queryParameters,
            'requestData': logRequestData,
            'headers': error.requestOptions.headers,
            'responseData': error.response?.data,
          });
          return handler.next(error);
        },
      ),
    );
  }

  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<BaseResponse<T>> post<T>(
    String url, {
    dynamic data,
    T Function(dynamic)? fromJsonT,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponse<T>(code: 500, msg: '网络请求失败: $e', result: null);
    }
  }

  Future<BaseResponse<T>> get<T>(
    String url, {
    T Function(dynamic)? fromJsonT,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponse<T>(code: 500, msg: '网络请求失败: $e', result: null);
    }
  }
}

/// 全局唯一 HTTP 客户端实例
final httpClient = HttpClient(baseUrl: baseUrl);
