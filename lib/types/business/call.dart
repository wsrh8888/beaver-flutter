import 'package:beaver/types/call.dart';

/// 通话仓库接口
abstract class CallRepositoryInterface {
  Future<List<CallHistory>> getCallHistory();
  Future<bool> deleteCallHistory(String callId);
  Future<bool> clearCallHistory();
}