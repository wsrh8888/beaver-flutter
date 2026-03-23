import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/call.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallHistoryRepository {
  final CallRepositoryInterface _callRepository;

  CallHistoryRepository({CallRepositoryInterface? callRepository}) 
    : _callRepository = callRepository ?? getIt<CallRepositoryInterface>();

  Future<List<CallHistory>> getCallHistory() async {
    return _callRepository.getCallHistory();
  }
  
  Future<bool> deleteCallHistory(String callId) async {
    return _callRepository.deleteCallHistory(callId);
  }
  
  Future<bool> clearCallHistory() async {
    return _callRepository.clearCallHistory();
  }
}
