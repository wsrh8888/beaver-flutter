// 通话相关 API 类型定义

class StartCallReq {
  final String conversationId;
  final int callType; // 1-私聊, 2-群聊
  final int callMode; // 1-语音起手, 2-视频起手

  StartCallReq({
    required this.conversationId,
    required this.callType,
    required this.callMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'callType': callType,
      'callMode': callMode,
    };
  }
}

/// 接受通话请求 (对应 GetCallTokenReq)
class AcceptCallReq {
  final String roomId;

  AcceptCallReq({required this.roomId});

  Map<String, dynamic> toJson() {
    return {'roomId': roomId};
  }
}

/// 拒绝通话请求 (对应 HangupCallReq)
class RejectCallReq {
  final String roomId;

  RejectCallReq({required this.roomId});

  Map<String, dynamic> toJson() {
    return {'roomId': roomId};
  }
}

/// 结束通话请求
class EndCallReq {
  final String conversationId;
  final int duration;

  EndCallReq({required this.conversationId, required this.duration});

  Map<String, dynamic> toJson() {
    return {'conversationId': conversationId, 'duration': duration};
  }
}

/// 通话信息响应
class CallInfoRes {
  final String conversationId;
  final String callerName;
  final String callerAvatar;
  final bool isIncoming;
  final String callType;
  final String roomId;
  final String roomToken;
  final String liveKitUrl;

  CallInfoRes({
    required this.conversationId,
    required this.callerName,
    required this.callerAvatar,
    required this.isIncoming,
    required this.callType,
    required this.roomId,
    required this.roomToken,
    required this.liveKitUrl,
  });

  factory CallInfoRes.fromJson(Map<String, dynamic> json) {
    return CallInfoRes(
      conversationId: json['conversationId'] ?? '',
      callerName: json['callerName'] ?? '',
      callerAvatar: json['callerAvatar'] ?? '',
      isIncoming: json['isIncoming'] ?? false,
      callType: json['callType'] ?? 'audio',
      roomId: json['roomId'] ?? '',
      roomToken: json['roomToken'] ?? '',
      liveKitUrl: json['liveKitUrl'] ?? '',
    );
  }
}

/// 通话历史记录响应
class CallHistoryRes {
  final String id;
  final String conversationId;
  final String callerId;
  final String callerName;
  final String callerAvatar;
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final String callType;
  final bool isIncoming;
  final bool isMissed;
  final String startTime;
  final String? endTime;
  final int? duration;

  CallHistoryRes({
    required this.id,
    required this.conversationId,
    required this.callerId,
    required this.callerName,
    required this.callerAvatar,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    required this.callType,
    required this.isIncoming,
    required this.isMissed,
    required this.startTime,
    this.endTime,
    this.duration,
  });

  factory CallHistoryRes.fromJson(Map<String, dynamic> json) {
    return CallHistoryRes(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? '',
      callerAvatar: json['callerAvatar'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverAvatar: json['receiverAvatar'] ?? '',
      callType: json['callType'] ?? 'audio',
      isIncoming: json['isIncoming'] ?? false,
      isMissed: json['isMissed'] ?? false,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'],
      duration: json['duration'],
    );
  }
}
