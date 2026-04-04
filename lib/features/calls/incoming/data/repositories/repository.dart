import 'package:beaver/types/call.dart';
import 'package:beaver/api/call.dart';
import 'package:beaver/types/api/call.dart' as api;

class CallIncomingRepository {
  Future<CallInfo> getCallInfo(String conversationId, String roomId) async {
    final response = await getCallInfoApi(roomId);
    if (response.code == 0 && response.result != null) {
      final res = response.result!;
      return CallInfo(
        conversationId: conversationId, // 补充会话ID
        callerName: res.callerName,
        callerAvatar: res.callerAvatar,
        isIncoming: res.isIncoming,
        callType: res.callType == 'video' ? CallType.video : CallType.audio,
        roomId: res.roomId.isNotEmpty ? res.roomId : roomId,
        roomToken: res.roomToken,
        liveKitUrl: res.liveKitUrl,
      );
    }
    throw Exception(response.msg);
  }
  
  Future<void> acceptCall(String roomId) async {
    final response = await acceptCallApi(api.AcceptCallReq(roomId: roomId));
    if (response.code != 0) {
      throw Exception(response.msg);
    }
  }
  
  Future<void> rejectCall(String roomId) async {
    final response = await rejectCallApi(api.RejectCallReq(roomId: roomId));
    if (response.code != 0) {
      throw Exception(response.msg);
    }
  }
}
