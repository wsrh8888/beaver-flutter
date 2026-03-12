import '../request/request.dart';
import 'api_client.dart';

/// 聊天相关接口 (对标 desktop render/api/chat.ts、main/api/chat.ts)
class ChatApi {
  const ChatApi(this._client);
  final ApiClient _client;

  /// 拉取会话列表、历史消息等可按需扩展
  Future<BaseResponse<T>> getConversationList<T>([T Function(dynamic)? fromJsonT]) {
    return _client.get<T>('/api/chat/conversation/list', fromJsonT: fromJsonT);
  }
}
