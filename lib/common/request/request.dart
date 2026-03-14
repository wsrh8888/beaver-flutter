/// 请求相关的基础类型
class BaseRequest {
  final Map<String, dynamic> data;

  BaseRequest(this.data);

  Map<String, dynamic> toJson() {
    return data;
  }
}