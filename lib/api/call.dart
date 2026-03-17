import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:beaver/api/index.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallApi {
  static Future<BaseResponse<CallInfo>> getCallInfo(String conversationId) async {
    try {
      final response = await dio.get('/call/info', queryParameters: {
        'conversationId': conversationId,
      });
      
      return BaseResponse.fromJson(
        response.data,
        (json) => CallInfo.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.error('获取通话信息失败');
    }
  }
  
  static Future<BaseResponse<bool>> acceptCall(String conversationId) async {
    try {
      final response = await dio.post('/call/accept', data: {
        'conversationId': conversationId,
      });
      
      return BaseResponse.fromJson(
        response.data,
        (json) => json as bool,
      );
    } catch (e) {
      return BaseResponse.error('接受通话失败');
    }
  }
  
  static Future<BaseResponse<bool>> rejectCall(String conversationId) async {
    try {
      final response = await dio.post('/call/reject', data: {
        'conversationId': conversationId,
      });
      
      return BaseResponse.fromJson(
        response.data,
        (json) => json as bool,
      );
    } catch (e) {
      return BaseResponse.error('拒绝通话失败');
    }
  }
  
  static Future<BaseResponse<CallInfo>> startCall(String conversationId, CallType callType) async {
    try {
      final response = await dio.post('/call/start', data: {
        'conversationId': conversationId,
        'callType': callType == CallType.video ? 'video' : 'audio',
      });
      
      return BaseResponse.fromJson(
        response.data,
        (json) => CallInfo.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.error('开始通话失败');
    }
  }
  
  static Future<BaseResponse<bool>> endCall(String conversationId, int duration) async {
    try {
      final response = await dio.post('/call/end', data: {
        'conversationId': conversationId,
        'duration': duration,
      });
      
      return BaseResponse.fromJson(
        response.data,
        (json) => json as bool,
      );
    } catch (e) {
      return BaseResponse.error('结束通话失败');
    }
  }
  
  static Future<BaseResponse<List<CallHistory>>> getCallHistory() async {
    try {
      final response = await dio.get('/call/history');
      
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as List).map((item) => CallHistory.fromJson(item)).toList(),
      );
    } catch (e) {
      return BaseResponse.error('获取通话历史失败');
    }
  }
  
  static Future<BaseResponse<bool>> deleteCallHistory(String callId) async {
    try {
      final response = await dio.delete('/call/history/$callId');
      
      return BaseResponse.fromJson(
        response.data,
        (json) => json as bool,
      );
    } catch (e) {
      return BaseResponse.error('删除通话历史失败');
    }
  }
  
  static Future<BaseResponse<bool>> clearCallHistory() async {
    try {
      final response = await dio.delete('/call/history');
      
      return BaseResponse.fromJson(
        response.data,
        (json) => json as bool,
      );
    } catch (e) {
      return BaseResponse.error('清空通话历史失败');
    }
  }
}
