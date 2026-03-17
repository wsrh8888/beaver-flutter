import 'package:beaver/features/calls/data/models/call.dart';

class CallPageRepository {
  Future<void> startCall(String conversationId) async {
    // 模拟开始通话
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> endCall(String conversationId) async {
    // 模拟结束通话
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> toggleMute(bool isMuted) async {
    // 模拟切换静音
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  Future<void> toggleCamera(bool isCameraOn) async {
    // 模拟切换摄像头
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  Future<void> toggleSpeaker(bool isSpeakerOn) async {
    // 模拟切换扬声器
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
