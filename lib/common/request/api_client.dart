import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beaver/common/request/response.dart';

/// API 客户端
class ApiClient {
  final String baseUrl;
  String? _token;

  ApiClient({required this.baseUrl});

  void updateToken(String token) {
    _token = token;
  }

  Future<BaseResponse<T>> post<T>(
    String path,
    {
      dynamic data,
      T Function(dynamic)? fromJsonT,
    },
  ) async {
    final url = Uri.parse('$baseUrl$path');
    final headers = {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);
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
    String path,
    {
      T Function(dynamic)? fromJsonT,
      Map<String, dynamic>? queryParameters,
    },
  ) async {
    final url = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParameters,
    );
    final headers = {
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
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
