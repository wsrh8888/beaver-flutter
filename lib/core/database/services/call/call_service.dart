import 'package:beaver/core/database/tables/call/call_history.dart';
import 'package:beaver/core/database/app_database.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallService {
  final AppDatabase _db;
  
  CallService(this._db);
  
  // 获取通话历史记录
  Future<List<CallHistory>> getCallHistory() async {
    final rows = await _db.select(_db.callHistoryTable).get();
    return rows.map((row) => _mapRowToCallHistory(row)).toList();
  }
  
  // 添加通话历史记录
  Future<void> addCallHistory(CallHistory callHistory) async {
    await _db.into(_db.callHistoryTable).insert(
      CallHistoryTableCompanion(
        callId: Value(callHistory.id),
        conversationId: Value(callHistory.conversationId),
        callerId: Value(callHistory.callerId),
        callerName: Value(callHistory.callerName),
        callerAvatar: Value(callHistory.callerAvatar),
        receiverId: Value(callHistory.receiverId),
        receiverName: Value(callHistory.receiverName),
        receiverAvatar: Value(callHistory.receiverAvatar),
        callType: Value(callHistory.callType == CallType.video ? 'video' : 'audio'),
        isIncoming: Value(callHistory.isIncoming),
        isMissed: Value(callHistory.isMissed),
        startTime: Value(callHistory.startTime),
        endTime: Value(callHistory.endTime),
        duration: Value(callHistory.duration),
      ),
    );
  }
  
  // 删除通话历史记录
  Future<void> deleteCallHistory(String callId) async {
    await (_db.delete(_db.callHistoryTable)..where((t) => t.callId.equals(callId))).go();
  }
  
  // 清空通话历史记录
  Future<void> clearCallHistory() async {
    await _db.delete(_db.callHistoryTable).go();
  }
  
  // 映射数据库行到CallHistory模型
  CallHistory _mapRowToCallHistory(CallHistoryTableData row) {
    return CallHistory(
      id: row.callId,
      conversationId: row.conversationId,
      callerId: row.callerId,
      callerName: row.callerName,
      callerAvatar: row.callerAvatar,
      receiverId: row.receiverId,
      receiverName: row.receiverName,
      receiverAvatar: row.receiverAvatar,
      callType: row.callType == 'video' ? CallType.video : CallType.audio,
      isIncoming: row.isIncoming,
      isMissed: row.isMissed,
      startTime: row.startTime,
      endTime: row.endTime,
      duration: row.duration,
    );
  }
}
