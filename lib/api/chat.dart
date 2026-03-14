import 'package:beaver/common/request/request.dart';
import 'package:beaver/common/config/env.dart';

/// 拉取会话列表
Future<BaseResponse<T>> getConversationListApi<T>(T Function(dynamic) fromJsonT) {
  final url = '$baseUrl/api/chat/conversation/list';
  return httpClient.get<T>(url, fromJsonT: fromJsonT);
}

