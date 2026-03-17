import 'package:beaver/features/calls/data/models/call.dart';
import 'package:uuid/uuid.dart';

class CallHistoryRepository {
  Future<List<CallHistory>> getCallHistory() async {
    // 模拟获取通话历史
    await Future.delayed(const Duration(seconds: 1));
    
    final now = DateTime.now();
    return [
      CallHistory(
        id: const Uuid().v4(),
        conversationId: 'conv_1',
        callerId: 'user_1',
        callerName: '张三',
        callerAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait&size=512x512',
        receiverId: 'user_2',
        receiverName: '李四',
        receiverAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait%20female&size=512x512',
        callType: CallType.video,
        isIncoming: true,
        isMissed: false,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now.subtract(const Duration(minutes: 50)),
        duration: 600,
      ),
      CallHistory(
        id: const Uuid().v4(),
        conversationId: 'conv_2',
        callerId: 'user_3',
        callerName: '王五',
        callerAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait%20male&size=512x512',
        receiverId: 'user_2',
        receiverName: '李四',
        receiverAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait%20female&size=512x512',
        callType: CallType.audio,
        isIncoming: true,
        isMissed: true,
        startTime: now.subtract(const Duration(hours: 3)),
        endTime: null,
        duration: null,
      ),
      CallHistory(
        id: const Uuid().v4(),
        conversationId: 'conv_3',
        callerId: 'user_2',
        callerName: '李四',
        callerAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait%20female&size=512x512',
        receiverId: 'user_4',
        receiverName: '赵六',
        receiverAvatar: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait%20young%20male&size=512x512',
        callType: CallType.video,
        isIncoming: false,
        isMissed: false,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.subtract(const Duration(hours: 23, minutes: 45)),
        duration: 900,
      ),
    ];
  }
  
  Future<void> deleteCallHistory(String callId) async {
    // 模拟删除通话历史
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  Future<void> clearCallHistory() async {
    // 模拟清空通话历史
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
