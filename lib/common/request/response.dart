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

/// 空响应
class EmptyResponse {
  EmptyResponse();

  factory EmptyResponse.fromJson(dynamic json) {
    return EmptyResponse();
  }
}