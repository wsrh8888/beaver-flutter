import 'package:beaver/types/call.dart';

class CallIncomingRepository {
  Future<CallInfo> getCallInfo(String conversationId) async {
    // 模拟获取通话信息
    await Future.delayed(const Duration(seconds: 1));
    return CallInfo(
      conversationId: conversationId,
      callerName: '张三',
      callerAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait&size=512x512',
      isIncoming: true,
      callType: CallType.video,
      roomId: 'room_${DateTime.now().millisecondsSinceEpoch}',
      roomToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      liveKitUrl: 'wss://example.livekit.io',
    );
  }
  
  Future<void> acceptCall(String conversationId) async {
    // 模拟接受通话
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> rejectCall(String conversationId) async {
    // 模拟拒绝通话
    await Future.delayed(const Duration(seconds: 1));
  }
}
