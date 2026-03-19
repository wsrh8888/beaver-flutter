import 'package:beaver/features/calls/data/models/call.dart';

/// 通话业务逻辑
class CallBusiness {
  /**
   * @description 获取通话历史记录
   */
  Future<List<CallHistory>> getCallHistory() async {
    // 模拟获取通话历史
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /**
   * @description 删除通话记录
   */
  Future<bool> deleteCallHistory(String callId) async {
    // 模拟删除通话记录
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /**
   * @description 清空通话记录
   */
  Future<bool> clearCallHistory() async {
    // 模拟清空通话记录
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}