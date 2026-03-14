import 'dart:convert';
import 'package:dio/dio.dart';

/// HTTP 客户端封装 (单例模式)
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  
  final Dio _dio;

  HttpClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: '', // 可以在运行时设置
      connectTimeout: const Duration(milliseconds: 50000),
      receiveTimeout: const Duration(milliseconds: 50000),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    ));

    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 可以在这里添加通用参数、日志等
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<BaseResponse<T>> post<T>(
    String url,
    {
      dynamic data,
      T Function(dynamic)? fromJsonT,
    }
  ) async {
    try {
      // 支持完整 URL 或相对路径
      final response = await _dio.post(
        url,
        data: data,
      );

      final responseData = response.data;
      return BaseResponse.fromJson(responseData, fromJsonT);
    } catch (e) {
      return BaseResponse<T>(
        code: 500,
        msg: '网络请求失败',
        result: null,
      );
    }
  }

  Future<BaseResponse<T>> get<T>(
    String url,
    {
      T Function(dynamic)? fromJsonT,
      Map<String, dynamic>? queryParameters,
    }
  ) async {
    try {
      // 支持完整 URL 或相对路径
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );

      final responseData = response.data;
      return BaseResponse.fromJson(responseData, fromJsonT);
    } catch (e) {
      return BaseResponse<T>(
        code: 500,
        msg: '网络请求失败',
        result: null,
      );
    }
  }
}

/// 全局 HTTP 客户端实例
final httpClient = HttpClient();


/// 响应相关的基础类型
class BaseResponse<T> {
  final int code;
  final String msg;
  final T? result;

  BaseResponse({required this.code, required this.msg, this.result});

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return BaseResponse<T>(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      result: fromJsonT != null && json['result'] != null
          ? fromJsonT(json['result'])
          : null,
    );
  }
}
