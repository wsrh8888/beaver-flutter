/// 统一 HTTP 响应格式 (对标 desktop IResponseSuccessData<T>)
class BaseResponse<T> {
  final int code;
  final String msg;
  final T? result;

  const BaseResponse({required this.code, required this.msg, this.result});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return BaseResponse(
      code: json['code'] as int? ?? -1,
      msg: json['msg'] as String? ?? '',
      result: json['result'] != null && fromJsonT != null
          ? fromJsonT(json['result'])
          : null,
    );
  }

  bool get isSuccess => code == 0;
}
