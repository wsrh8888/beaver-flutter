import 'package:beaver/features/calls/calls_page/data/models/call.dart';

class CallRepository {
  Future<CallInfo> getCallInfo(String conversationId) async {
    // 模拟获取通话信息
    await Future.delayed(const Duration(seconds: 1));
    return CallInfo(
      conversationId: conversationId,
      callerName: '张三',
      callerAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait&size=512x512',
      isIncoming: true,
    );
  }

  Future<void> startCall(String conversationId) async {
    // 模拟开始通话
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> endCall(String conversationId) async {
    // 模拟结束通话
    await Future.delayed(const Duration(seconds: 1));
  }
}
